require 'rubygems'
require 'eventmachine'
require 'em-http-request'
require 'em-synchrony'
require 'em-synchrony/em-http'

urls = %W[http://localhost:3000/1
          http://localhost:3000/2]

concurrency = 2
EventMachine.synchrony do
  EM::Synchrony::Iterator.new(urls, concurrency).each do |url, iter|
    Fiber.new do 
      client = EM::HttpRequest.new(url)
      response = client.get.response
      puts "#{url} #{response}"
      iter.next
    end.resume
  end
  EM.stop_event_loop
end

