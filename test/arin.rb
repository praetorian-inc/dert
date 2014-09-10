require 'minitest/unit'
require 'minitest/autorun'

require 'dert'
require 'yaml'

class TestArin < MiniTest::Unit::TestCase
  def setup
    @options = {}
    @options[:domain] = 'google.com'
    @options[:type] = 'arin'
    @options[:silent] = true
  end

  def test_equal_results
    results = Dert.run(@options)
    check = YAML.load_file('arin.yml')
    assert_equal results.to_s, check.to_s
  end
end
