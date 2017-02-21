
class Suite
	attr_accessor :id, :name, :description, :project_id, :base_id, :milestones
	def initialize(properties)
		@name = properties["name"]
		@description = properties["description"] || ""
		@project_id = properties["project_id"]
		@milestones = []
		if properties["id"]
			@base_id = properties["id"]
		end
	end

	def add
		response =
		    HTTParty.post(BASE_URL + "add_suite/#{@project_id}",
		        :verify => false,
		        :basic_auth => AUTH,
		        :headers => HEADERS,
		        :body => {  :name => self.name,
		        			:description => self.description
		        		 }.to_json )
		@id = response["id"]
		puts "\t[Suite added]".blue + " id: #{self.id} name: " + self.name.white + " base_id: #{self.base_id}"
	end

	def add_cases(project_definition)
		resource_subsections = ["Metrics", "Properties", "KPIs"]
		project_definition[:product_suite].each do |section_name, cases|
			section = Section.new({"name" => section_name, "suite_id" => self.id})
			section.add(self.project_id)
			cases.each do |case_title|
				test_case = Case.new({"title" => case_title, "section_id" => section.id})
				test_case.add
			end
			if section_name == "Resources"
				resource_subsections.each do |subsection_name|
					section = Section.new({"name" => subsection_name, "suite_id" => self.id})
					section.add(self.project_id)
					cases.each do |case_title|
						test_case = Case.new({"title" => case_title + " " + subsection_name, "section_id" => section.id})
						test_case.add
					end
				end
			end
		end		
	end

	def add_base_cases
		if self.base_id
			sections_response = Project.base_get_request("get_sections", self.base_id)
			cases_response = Project.base_get_request("get_cases", self.base_id)
			sections = {}
			cases = []

			sections_response.each do |section|
				base_section = Section.new(section)
				base_section.suite_id = self.id
				sections[base_section.base_id] = base_section
				sections[base_section.base_id].add(self.project_id)
			end

			cases_response.each do |test_case|
				base_case = Case.new(test_case)
				base_case.suite_id = self.id
				base_case.section_id = sections[base_case.section_id].id
				cases.push(base_case)
				cases.last.add
			end
		end
	end

	def set_milestones(arr)
		if self.name.include? "Ex Uno"
			@milestones.push(arr.find{ |item| item.name == "Ex Uno Data Provider" })
		else
			@milestones.push(arr.find{ |item| item.name == "Code Complete" })
		end
	end
end