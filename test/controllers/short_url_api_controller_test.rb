require "test_helper"
class ShortUrlApiControllerTest < ActionController::TestCase
	create_short_url_api_required_params = [:long_url_input, :customer_generate]
	create_short_url_api_test_case_one = {
		:long_url_input => "http://www.baidu.com",
		:customer_generate => false,
		:keyword => "rdat",
	}

	#必传参数测试
	create_short_url_api_required_params.each do |item|
		define_method "test_#{item}_missing" do
			url = "http://0.0.0.0/short_url/api/create_short_url"
			temp_value = create_short_url_api_test_case_one[item]
			create_short_url_api_test_case_one[item] = nil
			post "create_short_url",  create_short_url_api_test_case_one
			expected = {"success" => false, "message" => "参数#{item}未传入值", "data" => {}}.to_json
			assert_equal expected, @response.body
			assert_response :success
			create_short_url_api_test_case_one[item] = temp_value
		end
	end

	#返回值测试1
	def test_create_short_url_response_one
		create_short_url_api_test_case = {
			:long_url_input => "http://www.gggg.com/fagaf?fsa=fff",
			:customer_generate => false,
			:keyword => "",
		}
		url = "http://0.0.0.0/short_url/api/create_short_url"
		post "create_short_url",  create_short_url_api_test_case
		expected = {"success" => true, "message" => "成功", "data" => {}}
		assert_equal expected["success"], JSON.parse(@response.body)["success"]
		assert_equal expected["message"], JSON.parse(@response.body)["message"]
		assert_response :success
	end

	#返回值测试2
	def test_create_short_url_response_two
		create_short_url_api_test_case = {
			:long_url_input => "https://blog.csdn.net/jlaky/article/details/3581866",
			:customer_generate => true,
			:keyword => "fagdar",
		}
		url = "http://0.0.0.0/short_url/api/create_short_url"
		post "create_short_url",  create_short_url_api_test_case
		expected = {"success" => true, "message" => "成功", "data" => {"short_url" => "http://lh.cn:3000/fagdar"}}.to_json
		assert_equal expected, @response.body
		assert_response :success
	end

	#返回值测试3
	def test_create_short_url_response_three
		create_short_url_api_test_case = {
			:long_url_input => "blog.csdn.net/jlaky/article/details/3581866",
			:customer_generate => false,
			:keyword => "",
		}
		url = "http://0.0.0.0/short_url/api/create_short_url"
		post "create_short_url",  create_short_url_api_test_case
		expected = {"success" => false, "message" => "输入的url不合法,请重新输入", "data" => {}}.to_json
		assert_equal expected, @response.body
		assert_response :success
	end

	search_long_url_api_required_params = [:short_url_input]
	search_long_url_api_test_case_one = {
		:short_url_input => "http://lh.cn:3000/fagaff",
	}

	#必传参数测试
	search_long_url_api_required_params.each do |item|
		define_method "test_#{item}_missing" do
			url = "http://0.0.0.0/short_url/api/search_long_url"
			temp_value = search_long_url_api_test_case_one[item]
			search_long_url_api_test_case_one[item] = nil
			post "search_long_url",  search_long_url_api_test_case_one
			expected = {"success" => false, "message" => "参数#{item}未传入值", "data" => {}}.to_json
			assert_equal expected, @response.body
			assert_response :success
			search_long_url_api_test_case_one[item] = temp_value
		end
	end

	#search_long_url_api返回值测试1
	def test_search_long_url_api_response_one
		search_long_url_api_test_case = {
			:short_url_input => "http://lh.cn:3000/",
		}
		url = "http://0.0.0.0/short_url/api/search_long_url"
		post "search_long_url",  search_long_url_api_test_case
		expected = {"success" => false, "message" => "输入的url中没有短链关键词,请重新输入", "data" => {}}.to_json
		assert_equal expected, @response.body
		assert_response :success
	end	

	#search_long_url_api返回值测试2
	def test_search_long_url_api_response_two
		search_long_url_api_test_case = {
			:short_url_input => "lh.cn:3000",
		}
		url = "http://0.0.0.0/short_url/api/search_long_url"
		post "search_long_url",  search_long_url_api_test_case
		expected = {"success" => false, "message" => "输入的url不合法,请重新输入", "data" => {}}.to_json
		assert_equal expected, @response.body
		assert_response :success
	end	

	#search_long_url_api返回值测试3
	def test_search_long_url_api_response_three
		search_long_url_api_test_case = {
			:short_url_input => "http://lh.cn:3000/fdafdsfdsa",
		}
		url = "http://0.0.0.0/short_url/api/search_long_url"
		post "search_long_url",  search_long_url_api_test_case
		expected = {"success" => false, "message" => "输入的url没有命中任何数据,请重新输入", "data" => {}}.to_json
		assert_equal expected, @response.body
		assert_response :success
	end	

	#search_long_url_api返回值测试4
	def test_search_long_url_api_response_four
		search_long_url_api_test_case = {
			:short_url_input => "http://lh.cn:3000/aaabaa",
		}
		url = "http://0.0.0.0/short_url/api/search_long_url"
		post "search_long_url",  search_long_url_api_test_case
		expected = {"success" => true, "message" => "成功", "data" => {"long_url" => "http://www.baidu.com"}}
		assert_equal expected["success"], JSON.parse(@response.body)["success"]
		assert_equal expected["message"], JSON.parse(@response.body)["message"]		
		assert_response :success
	end	
end