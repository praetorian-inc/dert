module Dert
  class AXFR

    @res = Dnsruby::Resolver.new

    def self.query(domain)
      default_address = Resolv.getaddress(domain)
      results = []
      begin
        ret = @res.query(domain, Dnsruby::Types.NS)
        name_servers = []
        ret.answer.each do |x|
          name_servers << x.domainname.to_s
        end
        zt = Dnsruby::ZoneTransfer.new
        zoneref = []
        name_servers.each do |x|
          begin
            zt.server = x
            zoneref = zt.transfer(domain)
            break
          rescue Dnsruby::ResolvError => e
            #
          end
        end

        zoneref.each do |x|
          case x.type.to_s
            when 'SOA'
              results << {
                  address: default_address,
                  type: x.type.to_s,
                  hostname: x.name.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s
              }
            when 'A'
              results << {
                  address: x.address.to_s,
                  type: x.type.to_s,
                  hostname: x.name.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s
              }
            when 'MX'
              results << {
                  address: default_address,
                  type: x.type.to_s,
                  hostname: x.exchange.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s,
                  preference: x.preference.to_s
              }
            when 'NS'
              results << {
                  address: default_address,
                  type: x.type.to_s,
                  hostname: x.domainname.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s
              }
            when 'TXT'
              results << {
                  address: default_address,
                  type: x.type.to_s,
                  hostname: x.name.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s
              }
            when 'CNAME'
              results << {
                  address: default_address,
                  type: x.type.to_s,
                  hostname: x.name.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s
              }
            when 'SRV'
              results << {
                  address: default_address,
                  type: x.type.to_s,
                  hostname: x.name.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s
              }
            when 'LOC'
              results << {
                  address: default_address,
                  type: x.type.to_s,
                  hostname: x.name.to_s,
                  ttl: x.ttl.to_s,
                  klass: x.klass.to_s
              }
            else
              #
          end
        end
      rescue => e
        #
      end

      results
    end

  end

end