require 'minitest/unit'
require 'minitest/autorun'

path = File.dirname(__FILE__)
require "#{path}/../lib/dert"
require 'yaml'

class TestAXFR < MiniTest::Unit::TestCase
  def setup
    @options = {}
    @options[:domain] = 'zonetransfer.me'
    @options[:type] = 'axfr'
    @options[:silent] = true
  end

  def test_equal_results
    results = Dert.run(@options)
    pp results
    assert results.to_s
  end
end
