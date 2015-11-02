require 'minitest/unit'
require 'minitest/autorun'

path = File.dirname(__FILE__)
require "#{path}/../lib/dert"
require 'yaml'

class TestIPV6 < MiniTest::Unit::TestCase
  def setup
    path = File.dirname(__FILE__)
    @options = {}
    @options[:domain] = 'google.com'
    @options[:type] = 'ipv6'
    @options[:threads] = 1
    @options[:wordlist] = "#{path}/wordlists/short_hosts.txt"
    @options[:silent] = true
  end

  def test_equal_results
    results = Dert.run(@options)
    pp results
    assert results.to_s
  end
end