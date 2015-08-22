require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'yaml'

def get_url(domain_object, rel_route)
  if domain_object.is_a? Hash
    return domain_object['root'] + "/" + rel_route
  elsif domain_object.is_a? String
    return domain_object
  end
end

get '/*' do
  hostname = request.host
  route = params[:splat][0]

  YAML::load_file('redirects.yml').each do |code, zone|
    if zone.has_key? hostname
      url = get_url(zone[hostname], route)
      if url
        redirect url, code
      else
        halt 400, "Invalid configuration for #{hostname}"
      end
    end
  end

  halt 404, "#{hostname} hasn't been setup yet."
end