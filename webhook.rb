require 'sinatra'
require 'octokit'
require 'json'
require './validator'

if ENV['GITHUB_SECRET'].nil?
  die('GITHUB_SECRET')
end

if ENV['GITHUB_ACCESS_TOKEN'].nil?
  die('GITHUB_ACCESS_TOKEN')
end

if ENV['GITHUB_COLLABORATOR'].nil?
  die('GITHUB_COLLABORATOR')
end

enable :logging

stack = Faraday::RackBuilder.new do |builder|
  builder.response :logger
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack

helpers do
  def die(var)
    abort "#{var} is not set. Set #{var}! Hint: use 'cf env' to set environment variables."
  end

  def get_teams
    ENV['GITHUB_COLLABORATOR'].split(':')
  end
end

post '/' do
  logger.debug request.env
  request_body = request.body.read
  validator = Validator.new
  unless validator.validate_request(request.env['HTTP_X_HUB_SIGNATURE'], request_body)
    halt 400
  end
  json = JSON.parse request_body
  repo_name = json['repository']['full_name']
  client = Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
  get_teams.each do |team|
    unless client.add_team_repo(team, repo_name)
      logger.error "Failed to add #{team} to #{repo_name}"
      halt 500
    end
  end
  logger.info "Added #{ENV['GITHUB_COLLABORATOR']} to #{repo_name}"
end

