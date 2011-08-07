require 'rubygems'
require 'eventmachine'
require 'em-http-request'
require 'em-synchrony'
require 'em-synchrony/em-http'

urls = %W[http://localhost:3000/1
          http://localhost:3000/2]

pending = urls.length
EM.synchrony do
  urls.each do |url|
    Fiber.new do
      response = EM::HttpRequest.new(url).get.response
      puts "#{url} #{response}"

      pending -= 1
      EM.stop_event_loop if pending == 0
    end.resume
  end
end

