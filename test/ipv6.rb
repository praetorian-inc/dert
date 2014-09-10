path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:domain] = 'google.com'
options[:type] = 'ipv6'
options[:output] = 'ipv6.txt'
options[:threads] = 1
options[:wordlist] = "#{path}/wordlists/short_hosts.txt"
options[:silent] = true

Dert.run(options)