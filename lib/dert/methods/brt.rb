module Dert

  class BRT
    @res = Dnsruby::Resolver.new

    def self.query(domain, wordlist, dns_type)
      results = []
      default_ip = ''
      wildcard = false

      # Check if domain has wildcard DNS enabled.
      if self.wildcard?(domain)
        wildcard = true
        rendsub = rand(10000).to_s
        ret = @res.query("#{rendsub}.#{domain}", dns_type)
        default_ip = ret.answer[0].address.to_s
      end

      wordlist.each do |a|

        # A
        begin
          Timeout::timeout(5) {
            ret = @res.query("#{a}.#{domain}", dns_type)
            ret.answer.each do |x|
              unless x.address.to_s == default_ip
                results << {
                    address: x.address.to_s,
                    type: x.type.to_s,
                    hostname: x.name.to_s,
                    ttl: x.ttl.to_s,
                    klass: x.klass.to_s
                }
              end
            end
          }
        rescue => e
          #
        end
      end

      if wildcard
        results << {
            address: default_ip,
            type: 'A',
            hostname: "*.#{domain}"
        }
      end

      results
    end

    def self.wildcard?(domain)
      rendsub = rand(10000).to_s
      # A
      begin
        ret = @res.query("#{rendsub}.#{domain}", Dnsruby::Types.A)
      rescue
        return false
      end

      if ret.answer.length != 0
        true
      else
        false
      end
    end
  end
end