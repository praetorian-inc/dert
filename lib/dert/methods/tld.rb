module Dert
  class TLD

    @res = Dnsruby::Resolver.new

    def self.query(domain)
      results = []

      tlds = %w(
                com org net edu mil gov uk af al dz as ad ao ai aq ag ar am aw ac au at az bs bh bd bb by be bz bj bm
                bt bo ba bw bv br io bn bg bf bi kh cm ca cv ky cf td cl cn cx cc co km cd cg ck cr ci hr cu cy cz dk
                dj dm do tp ec eg sv gq er ee et fk fo fj fi fr gf pf tf ga gm ge de gh gi gr gl gd gp gu gt gg gn gw
                gy ht hm va hn hk hu is in id ir iq ie im il it jm jp je jo kz ke ki kp kr kw kg la lv lb ls lr ly li
                lt lu mo mk mg mw my mv ml mt mh mq mr mu yt mx fm md mc mn ms ma mz mm na nr np nl an nc nz ni ne ng
                nu nf mp no om pk pw pa pg py pe ph pn pl pt pr qa re ro ru rw kn lc vc ws sm st sa sn sc sl sg sk si
                sb so za gz es lk sh pm sd sr sj sz se ch sy tw tj tz th tg tk to tt tn tr tm tc tv ug ua ae gb us um
                uy uz vu ve vn vg vi wf eh ye yu za zr zm zw int gs info biz su name coop aero
              )

      target = domain.scan(/(\S*)[.]\w*\z/).join
      target.chomp!

      tlds.each do |a|
        # A
        begin
          ret = @res.query("#{target}.#{a}", Dnsruby::Types.A)
          ret.answer.each do |x|
            results << {
                address: x.address.to_s,
                type: x.type,
                hostname: x.name.to_s,
                ttl: x.ttl,
                klass: x.klass,
            }
          end
        rescue
          #
        end
      end
      results
    end
  end
end