require 'rubygems'
require 'bundler'
require 'sinatra'

Bundler.require

require './webhook.rb'

run Sinatra::Application

require 'rspec'
require 'rack/test'