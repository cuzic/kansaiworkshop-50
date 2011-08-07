require 'rubygems'
require 'eventmachine'
require 'em-http-request'

urls = %W[http://localhost:3000/1
          http://localhost:3000/2]

concurrency = 2
pending = urls.length
EventMachine.run do
  EM::Iterator.new(urls, concurrency).each do |url, iter|
    client = EM::HttpRequest.new(url).get
    client.callback do
      response = client.response
      puts "#{url} #{response}"
      pending -= 1
      EM.stop_event_loop if pending == 0
      iter.next
    end
  end
end

