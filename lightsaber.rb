require 'uri'
require 'rack/response'

# This is the class that resolves a given URL
# to what we need to redirect to
class Lightsaber

  def initialize(url)
    @url = URI(url)
  end

  def get_url(domain_object, rel_route)
    if domain_object.is_a? Hash
      return domain_object['root'] + "/" + rel_route
    elsif domain_object.is_a? String
      return domain_object
    end
  end

  def get_response_from_yml
    res = Rack::Response.new

    YAML::load_file('redirects.yml').each do |code, zone|
      if zone.has_key? @url.host.to_s
        url = get_url(zone[@url.host], @url.path)
        if url
          res.redirect url, code
        else
          res.status = 400
          res.body = "Invalid configuration for #{@url.host}"
        end
        return res
      end
    end
  end

  def not_setup_response
    res = Rack::Response.new
    res.status = 404
    res.body = "#{@url.host} hasn't been setup yet."
  end


  def get_response

    yml_res = get_response_from_yml
    return yml_res unless yml_res.nil?

    not_setup_response
  end
end