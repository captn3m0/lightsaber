require 'minitest/autorun'
require 'resolv'
require 'yaml'
require 'pp'
require_relative './lightsaber'

class TestConfig < Minitest::Test
  REDIRECTS = [301, 302]

  def test_txt_record
    saber = Lightsaber.new 'http://localhost:9292/test'
    res = saber.get_response_from_dns 'lstest.captnemo.in'

    assert_equal 'https://google.com', res.headers['Location']
    assert_equal 302, res.status
  end

end