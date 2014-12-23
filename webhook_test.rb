ENV['RACK_ENV'] = 'test'
ENV['GITHUB_SECRET'] = 'secret'
ENV['GITHUB_ACCESS_TOKEN'] = 'api_token'

require './webhook'
require 'test/unit'
require 'rack/test'

class WebhookTest < Test::Unit::TestCase
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end

  def test_it_says_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
  end

  def test_it_calls_with_octokit_when_a_new_repo_is_created
    payload = File.open('test_data/repository_hook.json').readlines()
    post '/', payload, 'CONTENT_TYPE' => 'application/json'
    assert last_response.ok?
  end
end