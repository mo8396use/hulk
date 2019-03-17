require "const/base62_const"
module ShortUrlUtil
	extend self
	SIXTYTWO_RADIX = 62
	REGEX_MATCHED = 0
	
	# 对自增id进行62进制转换,List位数不够时用0补充,最后进行统一洗牌
	# @param id 待转换的自增id
	# @return 编码字符串
	def base62(id)
		base62_list = []
		encoding_str = ""
		while id > 0
			remain = id%SIXTYTWO_RADIX
			base62_list << remain
			id = id/SIXTYTWO_RADIX
		end
		while base62_list.length < 6
			base62_list << 0
		end
		base62_list.shuffle.each do |item|
			encoding_str << Base62Const::NUM_MAPPING[item]
		end
		encoding_str
	end

	def process_url(short_url)
		base_url = Rails.configuration.base_short_url
		short_url.include?(base_url) ? short_url.gsub!(base_url, "") : nil
	end

	def check_url_validation(url)
		p url =~ /^((ht|f)tps?):\/\//
	end
end