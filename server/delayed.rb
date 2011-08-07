require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/async'
require 'eventmachine'

class Delayed < Sinatra::Base
  register Sinatra::Async
  
    aget "/1" do
      waitsec = rand * 2
      EM.add_timer waitsec do 
    	  body {"1"}
    	end
    end
    
    aget "/2" do
      waitsec = rand * 2
      EM.add_timer waitsec do 
    	  body {"2"}
    	end
    end
end


