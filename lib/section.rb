
class Section
	attr_accessor :id, :suite_id, :name, :description, :parent_id, :display_order, :depth, :base_id, :base_suite_id
	def initialize(properties)
		@name = properties["name"]
		@description = properties["description"] || ""	
		@suite_id = properties["suite_id"]
		@parent_id = properties["parent_id"]
		@display_order = properties["display_order"]
		@depth = properties["depth"]
		if properties["id"]
			@base_id = properties["id"]
			@base_suite_id = @suite_id
		end
	end

	def add(project_id)
		response =
		    HTTParty.post(BASE_URL + "add_section/#{project_id}",
		        :verify => false,
		        :basic_auth => AUTH,
		        :headers => HEADERS,
		        :body => {  :name => self.name,
		        			:description => self.description,
		        			:suite_id => self.suite_id,
		        			:parent_id => self.parent_id,
		        			:display_order => self.display_order,
		        			:depth => self.depth
		        		 }.to_json )
		@id = response["id"]
		puts "\t\t[Section added]".green + " id: #{self.id} name: " + self.name.white + " base_id: #{self.base_id}"
	end
end





  # {
  #   "id": 32,
  #   "suite_id": 4,
  #   "name": "Output",
  #   "description": null,
  #   "parent_id": null,
  #   "display_order": 2,
  #   "depth": 0
  # }