###########################################################################
# Author:                                                 Coleton Pierson #
# Company:                                                     Praetorian #
# Date:                                                    August 7, 2014 #
# Project:                 Dert - DNS Enumeration and Reconnaissance Tool #
# Description:                  Small DNS Recon tool created to integrate #
#                               into Project Mercury.                     #
###########################################################################
require 'dnsruby'
require 'rex'
require 'resolv'
require 'socket'
require 'timeout'
require 'json'

path = File.dirname(__FILE__)
require "#{path}/methods/init"

module Dert

  #############
  # Constants #
  #############
  module CONSTANTS
    ARIN = 1
    AXFR = 2
    BRT = 3
    IPV6 = 4
    RVL = 5
    SRV = 6
    STD = 7
    TDL = 8
    WILDCARD = 9
  end


  ###########################################################################
  # @method                                     query(domain, method, list) #
  # @param domain:                                   [String] Target Domain #
  # @param method:                                    [Integer] Enum Method #
  # @param list:                                  [String] Path to Wordlist #
  # @description                                         Start DNS queries. #
  ###########################################################################
  def self.query(domain, method, list=nil)
    case method
      when CONSTANTS::ARIN
        return ARIN.query(domain)
      when CONSTANTS::AXFR
        return AXFR.query(domain)
      when CONSTANTS::BRT
        return BRT.query(domain, list, Dnsruby::Types.A)
      when CONSTANTS::IPV6
        return BRT.query(domain, list, Dnsruby::Types.AAAA)
      when CONSTANTS::RVL
        return RVL.query(domain)
      when CONSTANTS::SRV
        return SRV.query(domain)
      when CONSTANTS::STD
        return STD.query(domain)
      when CONSTANTS::TDL
        return TDL.query(domain)
    end
  end


  ###########################################################################
  # @method               start(domain, method, threads, word_list, output) #
  # @param domain:                                   [String] Target Domain #
  # @param method:                                    [Integer] Enum Method #
  # @param threads:                            [Integer] Bruteforce Threads #
  # @param word_list:                             [String] Path to Wordlist #
  # @description                           Threaded DNS Enumeration method. #
  ###########################################################################
  def self.start(domain, method, threads = nil, word_list = nil, output = nil)

    results = []

    # Process for Brute Force DNS Enumeration
    if method == CONSTANTS::BRT or method == CONSTANTS::IPV6 or method == CONSTANTS::RVL

      # Count words/ips in list.
      count = File.foreach(word_list).inject(0) { |c, line| c+1 }
      # Words/IPs per thread
      per = (count / threads) + 1
      # Array of words/ips
      arr = []
      # Array of sets of words/ips per thread
      lists_per_thread = []

      thread_container = []

      # Parse words/ips from word list
      File.open(word_list).each_line do |x|
        if method == CONSTANTS::RVL
          tmp = Rex::Socket::RangeWalker.new(x.chomp.strip)
          if tmp.valid?
            tmp.each do |y|
              arr << y
            end
          end
        else
          arr << x.chomp
        end
      end

      # If word list count is greater than 50, use multiple threads.
      if arr.count > 50
        arr.each_slice(per) { |a| lists_per_thread << a }
      else
        lists_per_thread = [arr]
      end

      # Iterate through sets of words.
      lists_per_thread.each do |x|
        # Create a new thread and add it to a container
        thread_container << Thread.new {
          # Check if RVL, else BRT or IPV
          if method == CONSTANTS::RVL
            ret = []
            # Iterate through IP addresses
            x.each do |y|
              ret << self.query(y, method)
            end
          else
            # Send a single set of words to brute force
            ret = self.query(domain, method, x)
          end
          # Grab thread output
          Thread.current[:output] = ret
        }
      end

      # Join all threads and grab their outputs
      thread_container.each do |t|
        t.join
        results += t[:output] unless t[:output].empty?
      end

      # Process for Single Enumeration
    else
      results = self.query(domain, method)
    end

    # Write output to file if specified
    if output
      File.open(output, 'w') do |f|
        f.write(JSON.pretty_generate(results))
      end
    end

    # Return Results for Console output
    results
  end

  ###########################################################################
  # @method                                                   run (options) #
  # @param options:                                 [Hash] DNS Enum Options #
  # @description                                           Main CLI Method. #
  ###########################################################################
  def self.run(options)
    type = 0

    # RVL does not require a domain
    unless options[:type] == 'rvl'
      unless options[:domain]
        puts 'Invalid command. Try --help to view options.'
        exit
      end

      # remove http/https
      options[:domain].gsub!('https://', '')
      options[:domain].gsub!('http://', '')

      # Validate Domain
      unless options[:domain].match(/[a-zA-Z0-9\-]+\.[a-zA-z]{2,6}/)
        puts 'Invalid domain.'
        exit
      end
    end

    # Validate settings for brute force
    if %w(ipv6 brt).include? options[:type]
      if options[:threads] == nil or options[:domain] == nil or options[:wordlist] == nil
        puts "Usage #{File.basename($0)} -e <brt|ipv6> -d <domain> -w <wordlist> -t <threads>"
        exit
      end
    end

    # RVL requires threads and a word list
    if options[:type] == 'rvl'
      if options[:threads] == nil or options[:wordlist] == nil
        puts "Usage #{File.basename($0)} -e rvl -w <wordlist of ips> -t <threads>"
        exit
      end
    end

    # Validate wordlist
    if options[:wordlist]
      unless File.exist?(options[:wordlist])
        puts 'Word List not found.'
        exit
      end
    end

    # Validate threads
    if options[:threads]
      if options[:threads] > 100 or options[:threads] < 1
        puts 'Thread count must be between 1 and 100'
        exit
      end
    end

    # Convert string type to integer type
    case options[:type]
      when 'arin'
        type = 1
      when 'axfr'
        type = 2
      when 'brt'
        type = 3
      when 'ipv6'
        type = 4
      when 'rvl'
        type = 5
      when 'srv'
        type = 6
      when 'std'
        type = 7
      when 'tdl'
        type = 8
      else
        puts 'Wrong enumeration type. Try --help to view accepted enumeration inputs.'
        exit
    end

    # Start Enumeration
    results = self.start(options[:domain], type, options[:threads], options[:wordlist])

    # Save results to a file if specified
    if options[:output]
      File.open(options[:output], 'w') do |f|
        f.write(JSON.pretty_generate(results))
      end
    end

    # Print output to terminal unless silent
    unless options[:silent]
      puts 'Results:'
      if type == 1
        results.each do |x|
          puts "  Range: #{x[:cidr]}"
          puts "  Handle: #{x[:handle]}"
          puts "  Customer: #{x[:customer]}"
          puts "  Zip Code: #{x[:zip]}"
          puts ''
        end
      else
        results.each do |x|
          puts "  Hostname: #{x[:hostname]}"
          puts "    IP: #{x[:address]}"
          puts "    Type: #{x[:type]}"
        end
      end
    end

    # Return results as a hash
    results
  end

end