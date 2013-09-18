require 'sinatra'

get'/' do
  uri = 'https://www.google.co.jp/'
  @uris = [ uri  ]
  haml :index
end
