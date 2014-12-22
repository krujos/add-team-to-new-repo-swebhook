require 'sinatra'


github_secret=ENV['GITHUB_SECRET']

if github_secret.nil?
  abort 'GITHUB_SECRET is not set. Set GITHUB_SECRET! Hint: use "cf env" to set environment variables.'
end

get '/' do
  'Hello World'
end

post '/' do
  puts 'Received hook'
end

