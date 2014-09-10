path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:domain] = 'google.com'
options[:type] = 'srv'
options[:output] = 'srv.txt'
options[:silent] = true

Dert.run(options)