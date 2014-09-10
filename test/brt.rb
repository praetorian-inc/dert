path = File.dirname(__FILE__)
require 'dert'

options = {}
options[:domain] = 'rfizzle.ch'
options[:type] = 'brt'
options[:output] = 'brt.txt'
options[:threads] = 1
options[:wordlist] = "#{path}/wordlists/short_hosts.txt"
options[:silent] = true

Dert.run(options)