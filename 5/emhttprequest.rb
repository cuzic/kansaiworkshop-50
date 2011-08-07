require 'rubygems'
require 'eventmachine'
require 'em-http-request'

urls = %W[http://localhost:3000/1 http://localhost:3000/2]
pending = urls.length
EventMachine.run do
  Request = EM::HttpRequest
  urls.each do |url|
    client = Request.new(url).get

    client.callback do
      response = client.response
      puts "#{url} #{response}"
      pending -= 1
      EM.stop_event_loop if pending == 0
    end
  end
end

