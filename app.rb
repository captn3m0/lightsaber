require 'rubygems'
require 'pp'
require 'bundler/setup'
require 'sinatra'
require 'yaml'
require_relative './lightsaber'

get '/*' do
  saber = Lightsaber.new(request.url)
  saber.get_response.finish
end