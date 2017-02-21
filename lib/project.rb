
class Project
	@@qa_base_id = 2
	attr_accessor :id, :name, :announcement
	def initialize(properties)
		@name = properties["name"]
		@announcement = properties["announcement"] || ""
	end

	def add
		response =
		    HTTParty.post(BASE_URL + "add_project",
		        :verify => false,
		        :basic_auth => AUTH,
		        :headers => HEADERS,
		        :body => {  :name => self.name,
		        			:announcement => self.announcement,
		        			:show_announcement => true
		        		 }.to_json )
		@id = response["id"]
		puts "[Project added]".magenta + " id: #{self.id} name: " + self.name.white
	end

	def self.base_get_suites
		response =
		    HTTParty.get(BASE_URL + "get_suites/#{@@qa_base_id}",
		        :verify => false,
		        :basic_auth => AUTH,
		        :headers => HEADERS )
		JSON.parse(response.body)
	end

	def self.base_get_request(endpoint, suite_id)
		response =
		    HTTParty.get(BASE_URL + endpoint + "/#{@@qa_base_id}&suite_id=#{suite_id}",
		        :verify => false,
		        :basic_auth => AUTH,
		        :headers => HEADERS )
	end
end