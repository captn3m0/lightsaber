require 'rubygems'
require 'uri'
require 'rack'
require 'dnsruby'

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

  def get_response_from_dns (host)

    res = not_setup_response

    ret = Dnsruby::Resolver.new.query("_redirect.#{host}", 'TXT')
    ret.answer.rrsets.each do |rrset|
      rrset.rrs.each do |rr|
        if is_valid_lightsaber_record? rr.data
          url = get_redirect_from_dns_record rr.data
          if url =~ /\A#{URI::regexp}\z/
            res = Rack::Response.new
            res.redirect url
          end
        end
      end
    end
    res
  end

  def get_redirect_from_dns_record(data)
    data[6..-1]
  end

  def is_valid_lightsaber_record? (data)
    data[0..5] === 'v=lr1;'
  end

  def not_setup_response
    res = Rack::Response.new
    res.status = 404
    res.body = "#{@url.host} hasn't been setup yet."
  end


  def get_response
    get_response_from_dns @url.host
  end
end