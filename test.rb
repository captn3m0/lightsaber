require 'minitest/autorun'
require 'resolv'
require 'yaml'
require 'pp'

class TestConfig < Minitest::Test
  REDIRECTS = ['301', '302']
  def setup
    @config = YAML::load_file 'config.yml'
  end

  def test_redirect_sections
    @config.each do |section, zone|
      assert REDIRECTS.include? section.to_s
    end
  end

  def test_each_domain
    @config.each do |section, zone|
      zone.each do |domain, redirect|
        assert resolves_to_lightsaber(domain),
          "DNS for #{domain} isn't setup yet. See README"
      end
    end
  end

  def resolves_to_lightsaber(domain)
    flag = false
    Resolv::DNS.open do |dns|
      records = dns.getresources domain, Resolv::DNS::Resource::IN::CNAME
      records.each do |record|
        flag||=record.name.to_s === "lightsaber.captnemo.in"
      end
    end
    flag
  end
end