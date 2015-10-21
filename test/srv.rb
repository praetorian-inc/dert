require 'minitest/unit'
require 'minitest/autorun'

require 'dert'
require 'yaml'

class TestSRV < MiniTest::Unit::TestCase
  def setup
    @options = {}
    @options[:domain] = 'google.com'
    @options[:type] = 'srv'
    @options[:threads] = 1
    @options[:silent] = true
  end

  def test_equal_results
    results = Dert.run(@options)
    pp results
    assert results.to_s
  end
end