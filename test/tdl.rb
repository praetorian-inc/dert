path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:domain] = 'google.com'
options[:type] = 'tdl'
options[:output] = 'tdl.txt'
options[:silent] = true

Dert.run(options)