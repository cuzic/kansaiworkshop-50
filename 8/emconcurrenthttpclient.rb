require 'rubygems'
require 'eventmachine'
require 'em-http-request'
require 'fiber'

urls = %W[http://localhost:3000/1
          http://localhost:3000/2]

pending = urls.size
EM.run do
  Fiber.new do
    urls.each do |url|
      Fiber.new do
        f = Fiber.current
        client = EM::HttpRequest.new(url).get
        client.callback do
          f.resume client
        end

        client = Fiber.yield
        puts "#{url} #{client.response}"
        pending -= 1
        EM.stop_event_loop if pending == 0
      end.resume
    end
  end.resume
end
