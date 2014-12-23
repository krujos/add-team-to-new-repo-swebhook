require 'sinatra'
require 'Octokit'
require 'json'

github_secret = ENV['GITHUB_SECRET']
github_access_token = ENV['GITHUB_ACCESS_TOKEN']
github_collobarator = ENV['GITHUB_COLLABORATOR']

def die(var)
  abort "#{var} is not set. Set #{var}! Hint: use 'cf env' to set environment variables."
end

if github_secret.nil?
  die('GITHUB_SECRET')
end

if github_access_token.nil?
  die('GITHUB_ACCESS_TOKEN')
end

if github_collobarator.nil?
  die('GITHUB_COLLABORATOR')
end

get '/' do
  'Hello World'
end

post '/' do
  json = JSON.parse request.body.read
  repo = json['repository']['id']
  repo_name = json['repository']['full_name']
  client = Octokit::Client.new(:access_token => github_access_token)
  unless client.add_collaborator repo, github_collobarator, 'write'
    logger.error "Failed to add #{github_collobarator} to #{repo_name}"
  end
  logger.info "Added #{github_collobarator} to #{repo_name}"
end

