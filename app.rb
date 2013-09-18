require 'sinatra'

class URI::HTTP
  def not_scheme
    self.host + self.request_uri
  end
end

get'/' do
  @uris = [ URI.parse(request.url) ]
  haml :index
end

post'/' do
  @uris = []
  @uris.push(URI.parse(params[:url])) if params[:url].include?('http')
  haml :index
end
