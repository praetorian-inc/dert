module Dert

  class IPV6
    @res = Dnsruby::Resolver.new

    def self.query(domain, wordlist)
      results = []
      # AAAA
      begin
        ret = @res.query(domain, Dnsruby::Types.AAAA)
        ret.answer.each do |x|
          results << {
              address: x.address.to_s,
              type: x.type,
              hostname: x.name.to_s,
              ttl: x.ttl,
              klass: x.klass,
          }
        end
      rescue => e
        #
      end
      results
    end

  end
end