require 'sinatra'
require 'feed_searcher'
require 'rss'

class URI::HTTP
  def not_scheme
    self.host + self.request_uri
  end
end

get'/' do
  @uri  = URI.parse(request.url)
  @uris = [ @uri ]
  haml :index
end

post'/' do
  @uris = []
  if params[:url].include?('http')
    begin
      @uri = URI.parse(params[:url])
      feeds = FeedSearcher.search(params[:url])
      rss = RSS::Parser.parse(feeds.first)
      rss.items.each do |item|
        @uris.push(URI.parse(item.link.href))
      end
    rescue
      @uri = URI.parse(params[:url])
      @uris.push(@uri)
    end
  end
  haml :index
end
