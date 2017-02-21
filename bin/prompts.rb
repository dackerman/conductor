def prompt(label)
    puts "\n" + label + ":"
    response = ""
    while response == ""
        print "  => "
        response = STDIN.gets.strip
    end
    response
end

def prompt_bool?(label)
    puts "\n" + label + ":"
    valid = ["y", "n", "yes", "no", "t", "f", "true", "false"]
    response = ""
    while !(valid.include? response)
        print "  => "
        response = STDIN.gets.strip.downcase
    end
    ["y", "yes", "t", "true"].include? response
end

def prompt_base_suites()
    suites = []
    valid = ["y", "n", "yes", "no", "t", "f", "true", "false"]
    BASE_SUITES.each do |suite|
        puts "\n" + suite + "? (y/n):"
        response = ""
        while !(valid.include? response)
            print "  => "
            response = STDIN.gets.strip.downcase
        end
        if ["y", "yes", "t", "true"].include? response
            suites.push(suite)
        end
    end
    suites
end

def prompt_list(list)
    list.each_with_index do |item, index|
        print "  #{index + 1}. #{item[:name]}".ljust(40)
        puts item[:detail] ? "|  #{item[:detail]}" : ""
    end
    
    selection = -1
    until Array(1..list.size).include?(selection.to_i)
        print "  => "
        selection = STDIN.gets.strip
    end

    selection.to_i - 1
end

def delete_warning()
    # TO DO
end