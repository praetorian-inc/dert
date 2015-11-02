require 'minitest/unit'
require 'minitest/autorun'

path = File.dirname(__FILE__)
require "#{path}/../lib/dert"
require 'yaml'

class TestRVL < MiniTest::Unit::TestCase
  def setup
    path = File.dirname(__FILE__)
    @options = {}
    @options[:type] = 'rvl'
    @options[:threads] = 1
    @options[:wordlist] = "#{path}/wordlists/ips.txt"
    @options[:silent] = true
  end

  def test_equal_results
    results = Dert.run(@options)
    pp results
    assert results.to_s
  end
end