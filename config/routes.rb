Rails.application.routes.draw do
  root 'short_url#index'
  #short_url
  post 'short_url/create_short_url' => 'short_url#create_short_url'
  post 'short_url/search_for_long_url' => 'short_url#search_for_long_url'
  
  #admin
  get 'admin' => 'admin#index'

  #customer
  get   'customer' => 'customer#index'
  post 'customer/create_short_url' => 'customer#create_short_url'

  #short url api
  post 'short_url/api/create_short_url' => 'short_url_api#create_short_url'
  post 'short_url/api/search_long_url' => 'short_url_api#search_long_url'

  #access to long url
  get "/:keyword" => "short_url#access_to_long_url", constrains: {:keyword => /(0-9a-zA-Z){3,}/}
end
