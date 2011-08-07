require 'rubygems'
require 'eventmachine'
require 'em-http-request'
require 'em-synchrony'
require 'em-synchrony/em-http'

urls = %W[http://localhost:3000/1
          http://localhost:3000/2]

EM.synchrony do
  urls.each do |url|
    res = EM::HttpRequest.new(url).get.response
    puts "#{url} #{res}"
  end
  EM.stop_event_loop
end
