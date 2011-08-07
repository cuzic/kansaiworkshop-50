require 'net/http'
require 'uri'

urls = %W[http://localhost:3000/1 http://localhost:3000/2]
urls.each do |url|
  uri = URI(url)
	Net::HTTP.start(uri.host, uri.port) do |http|
	  res = http.get uri.path
	  puts "#{uri} #{res.body}"
	end
end
