path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:domain] = 'zonetransfer.me'
options[:type] = 'axfr'
options[:output] = 'axfr.txt'
options[:silent] = true

Dert.run(options)