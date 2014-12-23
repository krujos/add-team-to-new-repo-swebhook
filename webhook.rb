require 'sinatra'
require 'Octokit'
require 'json'

github_secret = ENV['GITHUB_SECRET']
github_access_token = ENV['GITHUB_ACCESS_TOKEN']

def die(var)
  abort "#{var} is not set. Set #{var}! Hint: use 'cf env' to set environment variables."
end

if github_secret.nil?
  die('GITHUB_SECRET')
end

if github_access_token.nil?
  die('GITHUB_ACCESS_TOKEN')
end



get '/' do
  'Hello World'
end

post '/' do
  the_json = JSON.parse request.body.read
  repo = the_json['repository']['full_name']
  puts repo
  client = Octokit::Client.new(:access_token => github_access_token)
  client.repository(repo)

end

