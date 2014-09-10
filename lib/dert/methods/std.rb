module Dert

  class STD

    @res = Dnsruby::Resolver.new

    def self.query(domain)

      default_address = Resolv.getaddress(domain)
      results = []

      # SOA
      begin
        ret = @res.query(domain, Dnsruby::Types.SOA)
        ret.answer.each do |x|
          results << {
              address: default_address,
              type: x.type.to_s,
              hostname: x.name.to_s,
              ttl: x.ttl.to_s,
              klass: x.klass.to_s
          }
        end

        # A
        ret = @res.query(domain, Dnsruby::Types.A)
        ret.answer.each do |x|
          results << {
              address: (x.address.to_s || default_address),
              type: x.type.to_s,
              hostname: x.name.to_s,
              ttl: x.ttl.to_s,
              klass: x.klass.to_s
          }
        end

        # MX
        ret = @res.query(domain, Dnsruby::Types.MX)
        ret.answer.each do |x|
          results << {
              address: default_address,
              type: x.type.to_s,
              hostname: x.exchange.to_s,
              ttl: x.ttl.to_s,
              klass: x.klass.to_s,
              preference: x.preference.to_s
          }
        end

        # NS
        ret = @res.query(domain, Dnsruby::Types.NS)
        ret.answer.each do |x|
          results << {
              address: default_address,
              type: x.type.to_s,
              hostname: x.domainname.to_s,
              ttl: x.ttl.to_s,
              klass: x.klass.to_s
          }
        end

        # TXT
        ret = @res.query(domain, Dnsruby::Types.TXT)
        ret.answer.each do |x|
          results << {
              address: default_address,
              type: x.type.to_s,
              hostname: x.name.to_s,
              ttl: x.ttl.to_s,
              klass: x.klass.to_s
          }
        end
      rescue
        #
      end

      results
    end

  end

end