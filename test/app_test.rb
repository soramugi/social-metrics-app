require File.expand_path(File.dirname(__FILE__)) + '/../app'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_says
    get '/'
    assert last_response.ok?
  end

  def test_it_says_post
    post '/', url: ''
    assert last_response.ok?
    post '/', url: 'http://hugehuge.com'
    assert last_response.ok?
  end

  def test_it_says_post_parse
    post '/parse', url: ''
    assert last_response.ok?
    post '/parse', url: 'http://hugehuge.com'
    assert last_response.ok?
  end
end
