require 'open-uri'

urls = %W[http://localhost:3000/1 http://localhost:3000/2]
threads = urls.map do |url|
  Thread.start(url) do |url|
    body = open(url).read
    puts "#{url} #{body}"
  end
end

threads.each{|t| t.join}
