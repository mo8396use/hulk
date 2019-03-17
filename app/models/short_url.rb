require "utils/short_url_util"
class ShortUrl < ActiveRecord::Base
	self.table_name = "short_url"
	SYSTEM_GENERATE = 0
	CUSTOMER_GENERATE = 1

	def self.insert_data(params)
		short_url = self.new
		short_url.url = params[:long_url_input]
		short_url.keyword = params[:keyword] if !params[:keyword].blank?
		short_url.create_type = !params[:customer_generate] ? SYSTEM_GENERATE : CUSTOMER_GENERATE
		short_url.addtime = Time.now.to_i
		short_url.save!
		short_url
	end
end
