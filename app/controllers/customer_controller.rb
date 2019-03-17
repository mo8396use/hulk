class CustomerController < ApplicationController
	def index
	end

	def create_short_url
		logger = get_logger("Customer.log")
		@not_error = true
		@short_url = ShortUrl.where("keyword = ?", params[:keyword]).first
		respond_to {|format| format.js} and return if !@short_url.nil?
		if ShortUrlUtil.check_url_validation(params[:long_url_input]) == ShortUrlUtil::REGEX_MATCHED
			begin
				params[:customer_generate] = true
				@short_url = ShortUrl.insert_data(params)
			rescue => e
				logger.tagged("short url") {logger.error("error: #{$!}. at: #{$@}")}
				@not_error = false
			end
		end
		respond_to {|format| format.js}
	end
end