require 'minitest/unit'
require 'minitest/autorun'

require 'dert'
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
    check = YAML.load_file('axfr.yml')
    assert_equal results.to_s, check.to_s
  end
end
