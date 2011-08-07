require 'open-uri'

urls = %W[http://localhost:3000/1 http://localhost:3000/2 ]
urls.each do |url|
  puts "#{url} #{open(url).read}"
end
