require 'socket'
module Dert
  class ARIN

    def self.parse(data)
      full_results = []
      data.each do |line|
        net_handle = line.match(/\(\s*(NET-\d{1,3}\-\d{1,3}\-\d{1,3}\-\d{1,3}\-\d{1,3})\s*\)/)
        range = line.match(/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\s+\-\s+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/)
        if net_handle and range
          customer_info = self.parse_net_handle(net_handle.to_s)
          full_results.push(customer_info)
        end
      end

      return full_results
    end

    def self.parse_net_handle(net_handle)
      customer_record = {}
      net_handle = net_handle.gsub('(', '')
      net_handle = net_handle.gsub(')', '')
      results = self.arin_results(net_handle)
      results.each do |line|
        ret = line.match(/(\w+):\s+(.*)\n/)
        if ret
          split = ret.to_s.split(':')
          key = split[0].strip
          value = split[1].strip
          if key == 'CustName' or key == 'NetHandle' or key == 'CIDR' or key == 'PostalCode'
            case key
              when 'CustName'
                key = :customer
              when 'NetHandle'
                key = :handle
              when 'CIDR'
                key = :cidr
              when 'PostalCode'
                key = :zip
            end
            customer_record[key] = value.to_s
          end
        end
      end

      return customer_record
    end

    def self.arin_results(company)
      client = TCPSocket.new('whois.arin.net', 43)
      client.puts(company.to_s)
      output = []

      ret = client.gets
      while ret != nil
        output.push(ret)
        ret = client.gets
      end
      client.close

      output
    end

    def self.query(domain)
      company = domain.gsub(/\.\w+$/, '')
      response = self.arin_results(company)
      self.parse(response)
    end

  end
end