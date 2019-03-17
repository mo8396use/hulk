require "utils/short_url_util"
class ShortUrlApiController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def create_short_url
		#参数非空检测
		required_params = [:long_url_input, :customer_generate]
		required_params.each do |item|
			render :json => mapping_render_format(false, "参数#{item}未传入值", {}) and return if params[item].nil?
		end
		logger = get_logger("short_url_api.log")
		if ShortUrlUtil.check_url_validation(params[:long_url_input]) == ShortUrlUtil::REGEX_MATCHED
			begin
				short_url = ShortUrl.insert_data(params)
				if params[:keyword].blank?
					short_url.keyword = ShortUrlUtil.base62(short_url.id)
					short_url.save!
				end
				render :json => mapping_render_format(true, "成功", {"short_url" => Rails.configuration.base_short_url + short_url.keyword})
			rescue => e
				logger.tagged("short url") {logger.error("error: #{$!}. at: #{$@}")}
				render :json => mapping_render_format(false, "系统内部错误,请联系管理员查看原因", {})
			end
		else
			render :json => mapping_render_format(false, "输入的url不合法,请重新输入", {})
		end
	end

	def search_long_url
		#参数非空检测
		required_params = [:short_url_input]
		required_params.each do |item|
			render :json => mapping_render_format(false, "参数#{item}未传入值", {}) and return if params[item].blank?
		end

		if ShortUrlUtil.check_url_validation(params[:short_url_input]) == ShortUrlUtil::REGEX_MATCHED
			keyword = ShortUrlUtil.process_url(params[:short_url_input])
			if !keyword.blank?
				long_url = get_long_url(keyword)
				if !long_url.blank?
					render :json => mapping_render_format(true, "成功", {"long_url" => long_url})
				else
					render :json => mapping_render_format(false, "输入的url没有命中任何数据,请重新输入", {})
				end
			else
				render :json => mapping_render_format(false, "输入的url中没有短链关键词,请重新输入", {})
			end
		else
			render :json => mapping_render_format(false, "输入的url不合法,请重新输入", {})
		end
	end

	private

	def get_long_url(keyword)
		short_url = ShortUrl.where("keyword = ?", keyword).first
		short_url.nil? ? "" : short_url.url
	end

	def mapping_render_format(success, msg, data)
		 {"success" => success, "message" => msg, "data" => data}
	end
end