path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:wordlist] = "#{path}/wordlists/ips.txt"
options[:type] = 'rvl'
options[:output] = 'rvl.txt'
options[:threads] = 1
options[:silent] = true

Dert.run(options)