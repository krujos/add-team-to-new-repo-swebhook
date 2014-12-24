ENV['RACK_ENV'] = 'test'
ENV['GITHUB_SECRET'] = 'secret'
ENV['GITHUB_ACCESS_TOKEN'] = 'api_token'
ENV['GITHUB_COLLABORATOR'] = '11223344'

require './webhook'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'

describe 'The webhook' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do
    @validator = double(Validator)
    #expect(Validator).to receive(:new) {@validator}
    @payload = File.read('spec/test_data/repository_hook.json')
    WebMock.disable_net_connect!(:allow_localhost => true)

    stub_request(:put, "https://api.github.com/teams/11223344/repos/jdk-testorg/t2").
        with(:body => "{\"name\":\"jdk-testorg/t2\"}",
             :headers => {'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token api_token', 'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 3.7.0'}).
        to_return(:status => 204, :body => "", :headers => {})
  end

  context 'post to / does the right thing' do

    it 'calls octokit when it receives a webhook' do
      #expect(@validator).to receive(:validate_request).with('secret', @payload) { true }
      post '/', @payload
      expect(last_response).to be_ok
    end

    #it 'fails when the secret is not right' do
      #expect(@validator).to receive(:validate_request).with('secret', @payload) { false }
      #post '/', @payload, 'HTTP_X-Hub-Signature' => 'secret'
      #expect(last_response).to be_bad_request
    #end
  end
end

