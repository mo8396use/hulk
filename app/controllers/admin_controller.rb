class AdminController < ApplicationController
	ITEMS_PER_PAGE = 10
	def index
		@short_urls = ShortUrl.where("status = ?", true).paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
		respond_to {|format| format.html}
	end
end