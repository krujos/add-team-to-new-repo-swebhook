require 'sinatra'
require 'Octokit'

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
  puts 'Received hook'

  client = Octokit.client.new(:access_token => github_access_token )
end

