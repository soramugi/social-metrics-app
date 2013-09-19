require 'sinatra'
require 'rss'

class URI::HTTP
  def title
    require 'net/http'
    require 'nkf'
    res = Net::HTTP.get_response(self)
    match = res.body.match(/<title.*?>(.+)<\/title>/i)

    if match
      NKF.nkf('-w', match[1])
    else
      "not scraping title"
    end
  end

  def not_scheme
    self.host + self.request_uri
  end
end

get'/' do
  @placeholder = 'URL or RSS address ...'
  @uris = [ URI.parse(request.url) ]
  haml :index
end

post'/' do
  @placeholder = ''
  @uris = []
  if params[:url].include?('http')
    @placeholder = params[:url]
    begin
      rss = RSS::Parser.parse(params[:url])
      rss.items.each do |item|
        @uris.push(URI.parse(item.link))
      end
    rescue
      @uris.push(URI.parse(params[:url]))
    end
  end
  haml :index
end
