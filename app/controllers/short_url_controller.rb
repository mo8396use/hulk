require "utils/short_url_util"
class ShortUrlController < ApplicationController
	def index
	end

	def search_for_long_url
		@short_url = nil
		@not_error = true
		if ShortUrlUtil.check_url_validation(params[:short_url_input]) == ShortUrlUtil::REGEX_MATCHED
			keyword = ShortUrlUtil.process_url(params[:short_url_input])
			@short_url = ShortUrl.where("keyword = ?", keyword).first if !keyword.nil?
		end
		respond_to {|format| format.js}
	end

	def create_short_url
		logger = get_logger("short_url.log")
		@not_error = true
		@short_url = nil
		if ShortUrlUtil.check_url_validation(params[:long_url_input]) == ShortUrlUtil::REGEX_MATCHED
			begin
				params[:customer_generate] = false
				@short_url = ShortUrl.insert_data(params)
				@short_url.keyword = ShortUrlUtil.base62(@short_url.id)
				@short_url.save!
			rescue => e
				logger.tagged("short url") {logger.error("error: #{$!}. at: #{$@}")}
				@not_error = false
			end
		end
		respond_to {|format| format.js}
	end

	def access_to_long_url
		short_url = request.env["REQUEST_URI"]
		keyword = ShortUrlUtil.process_url(short_url)
		short_url = ShortUrl.where("keyword = ?", keyword).first
		if short_url.nil?
			redirect_to "/404.html"
		else
			short_url.use_count += 1
			short_url.save
			redirect_to short_url.url, :status => 301
		end
	end
end