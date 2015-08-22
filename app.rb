require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'yaml'

get '/' do
  hostname = request.host
  YAML::load_file('redirects.yml').each do |code, zone|
    if zone.has_key? hostname
      redirect zone[hostname], code
    end
  end

  halt 404, "#{hostname} hasn't been setup yet."
end