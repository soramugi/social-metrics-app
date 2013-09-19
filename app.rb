require 'sinatra'
require 'feed_searcher'
require 'rss'

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
  if params[:url].include?('http')
    begin
      feeds = FeedSearcher.search(params[:url])
      rss = RSS::Parser.parse(feeds.first)
      rss.items.each do |item|
        @uris.push(URI.parse(item.link.href))
      end
    rescue
      @uris.push(URI.parse(params[:url]))
    end
  end
  haml :index
end
