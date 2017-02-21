
class Milestone
	attr_accessor :id, :name, :description, :project_id, :start_on, :due_on
	def initialize(properties)
		@name = properties["name"]
		@description = properties["description"] || ""
		@project_id = properties["project_id"]
		@start_on = properties["start_on"] || Time.now.to_i
		@due_on = properties["due_on"] || Time.now.to_i
	end

	def add
		response =
		    HTTParty.post(BASE_URL + "add_milestone/#{@project_id}",
		        :verify => false,
		        :basic_auth => AUTH,
		        :headers => HEADERS,
		        :body => {  :name => self.name,
		        			:description => self.description,
		        			:start_on => self.start_on,
		        			:due_on => self.due_on
		        		 }.to_json )
		@id = response["id"]
		puts "\t[Milestone added]".yellow + " id: #{self.id} name: " + self.name.white
	end
end