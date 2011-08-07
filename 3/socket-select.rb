require 'socket'
require 'uri'

class AsyncHTTPClient
  def initialize
    @urls = []
    @headers = {}
    @bodies  = {}
    @callbacks = {}
  end

  def add url, &block
    @urls << url
    @callbacks[url] = block
  end

  def header url
    @headers[url]
  end

  def body url
    @bodies[url]
  end

  def fetch
    sockets = []
    urls = {}
    @urls.each do |url|
      socket = _make_socket url
      urls[socket] = url
      sockets << socket
    end
    _read sockets, urls
  end

  def _make_socket url
    uri = URI(url)
    socket = TCPSocket.open(uri.host, uri.port)
    socket.write "GET #{uri.path} HTTP/1.0\r\n\r\n"
    return socket
  end

  def _read sockets, urls
    pending = sockets.length
    responses = Hash.new{|h, key| h[key] = ""}
    loop do
      readables, = IO.select sockets
      readables.each do |socket|
        url = urls[socket]
        if socket.eof? or socket.closed? then
          response = responses[url]
          _parse_response response, url
          pending -= 1
          sockets.delete socket
          next
        end
        responses[url] << socket.read_nonblock(65536)
      end
      break if pending == 0
    end
    return responses
  end

  def _parse_response response, url
    header, *bodies = response.split "\r\n\r\n"
    body = bodies.join("")
    @headers[url] = header
    @bodies[url] = body
    if @callbacks[url] then
      @callbacks[url].call header, body
    end
  end
end

urls = %W[http://localhost:3000/1 http://localhost:3000/2]
client = AsyncHTTPClient.new
urls.each do |url|
  client.add url do |header, body|
    puts "#{url} #{body}"
  end
end
client.fetch
