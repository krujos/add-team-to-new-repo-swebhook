require 'sinatra'
require 'octokit'
require 'json'
require './validator'

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

stack = Faraday::RackBuilder.new do |builder|
  builder.response :logger
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack

post '/' do
  request_body = request.body.read
  #validator = Validator.new
  logger.info headers.keys
  #unless validator.validate_request(headers['X-Hub-Signature'], request_body)
  #  halt 400
  #end
  json = JSON.parse request_body
  repo_name = json['repository']['full_name']
  client = Octokit::Client.new(:access_token => github_access_token)
  unless client.add_team_repo(github_collobarator, repo_name)
    logger.error "Failed to add #{github_collobarator} to #{repo_name}"
    halt 500
  end
  logger.info "Added #{github_collobarator} to #{repo_name}"
end

