module Dert

  class RVL

    @res = Dnsruby::Resolver.new

    def self.query(domain)

      results = []

      default_address = Resolv.getaddress(domain)

      begin
        ret = @res.query(default_address, Dnsruby::Types.PTR)
        ret.answer.each do |x|
          results << {
              address: default_address,
              type: x.type.to_s,
              hostname: x.domainname.to_s,
              ttl: x.ttl.to_s,
              klass: x.klass.to_s
          }
        end
      rescue => e
        #
      end

      results
    end

  end

end