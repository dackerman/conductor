class Case
    attr_accessor :id, :section_id, :suite_id, :title, :custom_steps, :custom_expected, :custom_preconds, :base_id
    def initialize(properties)
        @title = properties["title"]
        @custom_steps = properties["custom_steps"] || ""
        @custom_expected = properties["custom_expected"] || ""
        @custom_preconds = properties["custom_preconds"] || ""
        @section_id = properties["section_id"]
        if properties["id"]
          @base_id = properties["id"]
        end
    end

    def add
        response =
            HTTParty.post(BASE_URL + "add_case/#{@section_id}",
                :verify => false,
                :basic_auth => AUTH,
                :headers => HEADERS,
                :body => {  :title => self.title,
                            :custom_steps => self.custom_steps,
                            :custom_expected => self.custom_expected,
                            :custom_preconds => self.custom_preconds
                         }.to_json )
        @id = response["id"]
        @suite_id = response["suite_id"]
        puts "\t\t\t[Case added]".cyan + " id: #{self.id} title: " + self.title[0..29].white + " section_id: #{self.section_id}"
    end
end

# *** Example API Response ***
# {
#   "id": 272,
#   "title": "EUDP output is an accurate representation of the monitored hardware.",
#   "section_id": 32,
#   "template_id": 1,
#   "type_id": 7,
#   "priority_id": 2,
#   "milestone_id": null,
#   "refs": "DP-1",
#   "created_by": 4,
#   "created_on": 1476820439,
#   "updated_by": 4,
#   "updated_on": 1477408951,
#   "estimate": null,
#   "estimate_forecast": null,
#   "suite_id": 4,
#   "custom_preconds": null,
#   "custom_steps": "Observe the collection output. (rake collection)",
#   "custom_expected": "Collection output shall be representative of the technology being monitored.",
#   "custom_steps_separated": null,
#   "custom_mission": null,
#   "custom_goals": null
# }

