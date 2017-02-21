require 'colorize'
require 'httparty'
require 'yaml'
require 'json'

RAKE_ROOT = File.expand_path(File.dirname(__FILE__))
Dir.glob("#{RAKE_ROOT}/bin/**/*.rb").each { |r| require_relative r }
Dir.glob("#{RAKE_ROOT}/lib/**/*.rb").each { |r| require_relative r }

check_ruby_version()

namespace :conductor do

    desc "Generate auth file".green
    task :set_auth do
        begin
            auth = {:username => "", :password => ""}
            auth[:username] = prompt("TestRail Username")
            auth[:password] = prompt("TestRail Password/API Key")

            check_dir("#{RAKE_ROOT}/config")
            File.open("#{RAKE_ROOT}/config/auth.yml", "w") do |f|
                f.write(auth.to_yaml)
            end

            puts "\nSuccess! config/auth.yml has been generated.".green
        rescue => e
            puts e.message.red
            rescue Interrupt
                puts "\n"
        end
    end

    desc "List projects".green
    task :list_projects do
        begin
            response = get_projects()
            projects = "" 
            response.each do |project|
                projects += "#{project["id"]}: " + project["name"] + "\n"
            end

            code = handle_response_code(response.code)
            puts (code.include? "Success") ? code.green + "\n" + projects.green : code.red

        rescue => e
            puts e.message.red
        end
    end

    desc "Create a project configuration template".green
    task :config do
        begin
            config = CONFIG.clone
            config[:product_name] = prompt("Product Name")
            config[:release] = prompt("Release (R1, R2, R3, R4, R5, R6)") # TO DO: Change prompt to selection [R1, R2, R3, R4, R5, R6]
            config[:year] = prompt("Year") # TO DO: Validate year format
            config[:refresh] = prompt_bool?("Is this a refresh? (y/n)")
            config[:base_suites] = prompt_base_suites()
            config[:spec] = prompt("Spec URL")
            config[:env] = prompt("Confluence Environment URL")
            if config[:base_suites].include? "vROps"
                config[:vrops_versions] = prompt("Target vROps versions")
            else
                config.delete(:vrops_versions)
            end
            unless prompt_bool?("Include product specific case template? (y/n)")
                config.delete(:product_suite)
            end

            check_dir("#{RAKE_ROOT}/config/project_definitions")
            filename = sanitize(config[:product_name]) + "_" + Time.now.strftime("%Y-%m-%d-%H%M%S") + ".yml"
            File.open("config/project_definitions/" + filename, "w") do |f|
                    f.write(config.to_yaml( :ExplicitTypes => true ))
            end
            puts ("\nSuccess! config/project_definitions/" + filename + " has been generated.").green
        rescue => e
            puts e.message.red
            rescue Interrupt
                puts "\n"
        end
    end

    desc "Generate a project".green
    task :generate do
        begin
            path = 'config/project_definitions/*.yml'
            selection = select_project_definition(path)
            project_definition = YAML.load_file(Dir.glob(path)[selection])

            mid_title = (project_definition[:refresh] ? " - Refresh" : "")
            project_name = 	project_definition[:product_name] + mid_title + " - " + project_definition[:release] + " " + project_definition[:year]
            project_announcement = "Spec: " + project_definition[:spec] + "\nEnvironment: " + project_definition[:env]
            if project_definition[:vrops_versions]
                project_announcement += "\nvROps Versions: " + project_definition[:vrops_versions]
            end

            project = Project.new({ "name" => project_name, "announcement" => project_announcement })
            project.add

            milestones = []
            MILESTONES.each do |milestone|
                if (project_definition[:base_suites].include? "Ex Uno") || !(milestone.include? "Ex Uno")
                    milestones.push(Milestone.new({ "name" => milestone, "project_id" => project.id }))
                end
            end

            milestones.each { |milestone| milestone.add }

            suites = []
            if project_definition[:product_suite]
                product_suite = Suite.new({
                    "name" => project_definition[:product_suite].shift[1] + " Suite",
                    "project_id" => project.id,
                    "is_product_suite" => true })
                suites.push(product_suite)
            end

            suites_response = Project.base_get_suites

            suites_response.each do |suite|
                project_definition[:base_suites].each do |def_suite|
                    if suite["name"].include? def_suite
                        # puts suite["name"].green + " contains " + def_suite.green
                        base_suite = create_base_suite(suite, project.id)
                        suites.push(base_suite)
                    end
                end
            end

            suites.each do |suite|
                suite.add
                suite.set_milestones(milestones)
                if suite.base_id
                    suite.add_base_cases
                else # Product Suite
                    suite.add_cases(project_definition)
                end

                # Create run for each suite and assign milestone
                suite.milestones.each do |milestone|
                    run = Run.new({
                        "name" => suite.name + " Run", 
                        "suite_id" => suite.id, 
                        "milestone_id" => milestone.id })
                    run.add(project.id)
                end
            end
        rescue => e
            puts e.message.red
            rescue Interrupt
                puts "\n"
        end
    end

    desc "Add a suite to an existing project".green
    task :add_suite do
        begin
            project = select_project()
            suite_type = select_suite_type()
            if (suite_type == "Base Suite")
                base_suite = create_base_suite(select_base_suite(project), project["id"])
                base_suite.add
                base_suite.add_base_cases
            else # Product Suite
                path = 'config/project_definitions/product_suite/*.yml'
                selection = select_suite_definition(path)
                project_definition = YAML.load_file(Dir.glob(path)[selection])
                product_suite = Suite.new({
                    "name" => project_definition[:product_suite].shift[1] + " Suite",
                    "project_id" => project["id"],
                    "is_product_suite" => true })
                product_suite.add
                product_suite.add_cases(project_definition)
            end
        rescue => e
            puts e.message.red
            rescue Interrupt
                puts "\n"
        end
    end

    task :delete, [:id] do |t, args|
        begin
            response =
                    HTTParty.post(BASE_URL + "/delete_project/#{args.id}",
                        :verify => false,
                        :basic_auth => AUTH,
                        :headers => HEADERS )
            
            if handle_response_code(response.code).include? "Success"
                puts "Project (ID: #{args.id}) has been deleted!"
            end
        rescue => e
            puts e.message.red
        end
    end
end
