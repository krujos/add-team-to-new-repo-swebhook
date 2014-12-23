ENV['RACK_ENV'] = 'test'
ENV['GITHUB_SECRET'] = 'secret'
ENV['GITHUB_ACCESS_TOKEN'] = 'api_token'
ENV['GITHUB_COLLABORATOR'] = 'krujos/other_folks'

require './webhook'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'The webhook app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    WebMock.disable_net_connect!(:allow_localhost => true)

    stub_request(:put, "https://api.github.com/repositories/27496774/collaborators/krujos/other_folks").
        with(:body => "write",
             :headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token api_token', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 3.7.0'}).
        to_return(:status => 200, :body => "", :headers => {})
  end

  it 'says hello world' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it 'calls octokit when it receives a webhook' do
    payload = File.read('test_data/repository_hook.json')
    post '/', payload, 'CONTENT_TYPE' => 'application/json'
    expect(last_response).to be_ok
  end
end
