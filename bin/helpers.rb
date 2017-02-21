def get_projects
    response =
        HTTParty.get(BASE_URL + "/get_projects",
            :verify => false,
            :basic_auth => AUTH,
            :headers => HEADERS )
end

def get_suites(project_id)
    response =
        HTTParty.get(BASE_URL + "get_suites/#{project_id}",
            :verify => false,
            :basic_auth => AUTH,
            :headers => HEADERS )
    JSON.parse(response.body)
end

def create_base_suite(suite, project_id)
    base_suite = Suite.new(suite)
    base_suite.project_id = project_id
    base_suite
end

def handle_response_code(code)
    case code
        when 200
            "Success [#{code}]"
        when 400
            "Client Error [#{code}]: Bad Request."
        when 401
            "Client Error [#{code}]: Unauthorized."
        when 500...600
            "Server Error [#{code}]: Server was unable to handle request."
    end
end

def check_dir(name)
    unless File.directory?(name)
        FileUtils.mkdir_p(name)
    end
end

def check_ruby_version()
  version = `ruby -v`
  if version.include?('jruby')
    puts "JRuby is incompatible! Use Ruby".red
    puts "Do: 'rvm use <2.x.x>' to switch to Ruby".green
    exit 1
  elsif version.split('.')[0].split(' ')[1].to_i < 2
    puts "You must use Ruby 2.x.x!".red
    exit 1
  end
end

def select_project_definition(path)
    begin
        puts "\nSelect a project definition:".magenta
        list = []
        Dir.glob(path).each do |file|
            definition = YAML.load_file(file)
            if definition[:product_name]
                list.push({
                    :name => definition[:product_name],
                    :detail => file.split('/')[-1]
                })
            end
            list.push()
        end

        prompt_list(list)
    rescue => e
        puts e.message.red
        rescue Interrupt
            puts "\n"
    end
end

def select_suite_definition(path)
    begin
        puts "\nSelect a suite definition:".magenta
        list = []
        Dir.glob(path).each do |file|
            definition = YAML.load_file(file)
            if definition[:product_suite][:suite_name]
                list.push({
                    :name => definition[:product_suite][:suite_name],
                    :detail => file.split('/')[-1]
                })
            end
            list.push()
        end

        prompt_list(list)
    rescue => e
        puts e.message.red
        rescue Interrupt
            puts "\n"
    end
end

def select_project()
    projects = get_projects()
    list = []
    projects.each do |project|
        if !project["is_completed"]
            list.push({ 
                :name => project["name"], 
                :id => project["id"]  
            })
        end
    end

    puts "\nSelect a project:".magenta
    selection_id = list[prompt_list(list)][:id]
    projects.find{ |project| project["id"] == selection_id }
end

def select_suite_type()
    choices = [{:name => "Base Suite"}, {:name => "Product Suite"}]
    puts "\nWhat kind of suite do you want to add?".magenta
    choices[prompt_list(choices)][:name]
end

def select_base_suite(project)
    base_suites = Project.base_get_suites
    disallowed = get_suites(project["id"]).map { |suite| suite["name"] }
    list = []
    base_suites.each do |suite|
        unless disallowed.include? suite["name"]
            list.push({
                :name => suite["name"],
                :detail => suite["description"],
                :base_id => suite["id"]
            })
        end
    end

    if list.empty?
        abort("This project already includes every base suite.".yellow)
    end

    puts "\nWhich base suite would you like to add to ".magenta +
         "[#{project["name"]}]".green +
         "?".magenta
    selection_id = list[prompt_list(list)][:base_id]
    base_suites.find{ |suite| suite["id"] == selection_id }
end

def sanitize(filename)
  # Remove any character that aren't 0-9, A-Z, or a-z
  filename.gsub(/[^0-9A-Z]/i, '_')
end

