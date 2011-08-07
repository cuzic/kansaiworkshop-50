require 'rubygems'
require 'eventmachine'
require 'uri'

urls = %W[http://localhost:3000/1 http://localhost:3000/2]
pending = urls.length
EventMachine.run do
  Client = EM::Protocols::HttpClient
  urls.each do |url|
    uri = URI(url)
    client = Client.request(
      :host => uri.host,
      :port => uri.port,
      :request => uri.path,
    )
#    client = Client.request(uri)

    client.callback do |response|
      puts "#{url} #{response[:content]}"
      pending -= 1
      EM.stop_event_loop if pending == 0
    end
  end
end

