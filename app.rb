require 'sinatra'
require 'json'
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
      "Not Scraping Title"
    end
  end

  def not_scheme
    self.host + self.request_uri
  end
end

get'/' do
  @placeholder = 'URL or RSS address ...'
  haml :index
end

post'/' do
  return '' unless params[:url].include?('http')
  @uri = URI.parse(params[:url])
  haml :socialcount, layout: false
end

post '/parse' do
  urls = []
  begin
    rss = RSS::Parser.parse(params[:url])
    rss.items.each do |item|
      urls << item.link
    end
  rescue
    urls << params[:url]
  end

  content_type :json, :charset => 'utf-8'
  urls.to_json
end
