path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:domain] = 'google.com'
options[:type] = 'std'
options[:output] = 'std.txt'
options[:silent] = true

Dert.run(options)