
class Run
	attr_accessor :id, :name, :description, :suite_id, :milestone_id
	def initialize(properties)
		@name = properties["name"]
		@description = properties["description"] || ""
		@suite_id = properties["suite_id"]
		@milestone_id = properties["milestone_id"]
	end

	def add(project_id)
		response =
		    HTTParty.post(BASE_URL + "add_run/#{project_id}",
		        :verify => false,
		        :basic_auth => AUTH,
		        :headers => HEADERS,
		        :body => {  :name => self.name,
		        			:description => self.description,
		        			:suite_id => self.suite_id,
		        			:milestone_id => self.milestone_id
		        		 }.to_json )
		@id = response["id"]
		puts "\t\t[Run added]".red + " id: #{self.id} name: " + self.name.white + " milestone_id: #{self.milestone_id}"
	end
end

# {
# 	"assignedto_id": 6,
# 	"blocked_count": 0,
# 	"completed_on": null,
# 	"config": "Firefox, Ubuntu 12",
# 	"config_ids": [
# 		2,
# 		6
# 	],
# 	"created_by": 1,
# 	"created_on": 1393845644,
# 	"custom_status1_count": 0,
# 	"custom_status2_count": 0,
# 	"custom_status3_count": 0,
# 	"custom_status4_count": 0,
# 	"custom_status5_count": 0,
# 	"custom_status6_count": 0,
# 	"custom_status7_count": 0,
# 	"description": null,
# 	"failed_count": 2,
# 	"id": 81,
# 	"include_all": false,
# 	"is_completed": false,
# 	"milestone_id": 7,
# 	"name": "File Formats",
# 	"passed_count": 2,
# 	"plan_id": 80,
# 	"project_id": 1,
# 	"retest_count": 1,
# 	"suite_id": 4,
# 	"untested_count": 3,
# 	"url": "http://<server>/testrail/index.php?/runs/view/81"
# }



