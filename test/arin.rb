path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:domain] = 'google.com'
options[:type] = 'arin'
options[:output] = 'arin.txt'
options[:silent] = true

Dert.run(options)