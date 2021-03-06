require 'ipaddr'

module Ip2Something
	class Index
		def initialize path='~/.ip2something'
			folder = File.expand_path(path)
			@keys = File.new("#{folder}/ip.keys", 'r')
			@datas = File.new("#{folder}/ip.data", 'r')
			@length = File.size("#{folder}/ip.keys") / 10
		end
		def key poz
			@keys.seek poz * 10
			@keys.read 4
		end
		def data poz
			@keys.seek poz * 10 + 4
			poz, size = @keys.read(6).unpack('Nn')
			@datas.seek poz
			@datas.read size
		end
		def search ip
			k = Array[IPAddr.new(ip).to_i].pack('N')
			high = @length
			low = 0
			while true:
				pif = (high+low) / 2
				if key(pif) == k or (pif > 1 and key(pif-1) < k and key(pif) > k)
					datas = data(pif -1).split('|')
					return {
						:country_code => datas[0],
						:country_name => datas[1],
						:region_code  => datas[2],
						:region_name  => datas[3],
						:city         => datas[4],
						:zipcode      => datas[5],
						:latitude     => datas[6],
						:longitude    => datas[7],
						:metrocode    => datas[8]
					}
				end
				if key(pif) > k
					high = pif
				else
					low = pif
				end
			end
		end
	end
end
