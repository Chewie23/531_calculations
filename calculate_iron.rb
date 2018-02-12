#
#TODO
#Have an automated way to increase TM. Maybe on user's choice?
#   I personally like to automate

require 'yaml'

def process_yaml(log_file)
    y_file = YAML.load_file(log_file)
    return y_file
end

def get_multiple_of_5(num)
    return (num/5).floor * 5
end

def calc_week_1(tm)
    return [0.65, 0.75, 0.85].map!{|x| get_multiple_of_5(x*tm)}
end

def calc_week_2(tm)
    return [0.70, 0.80, 0.90].map!{|x| get_multiple_of_5(x*tm)}
end

def calc_week_3(tm)
    return [0.75, 0.85, 0.95].map!{|x| get_multiple_of_5(x*tm)}
end

def calc_week_4(tm)
     return [0.60, 0.60, 0.60].map!{|x| get_multiple_of_5(x*tm)}
end

def main

    lifts = {"1" => :Squat, "2" => :OHP, 
             "3" => :SquatII, "4" =>:OHPII, 
             "5" => :Deadlift, "6" => :Bench}
    weeks = {"1" => method(:calc_week_1), 
             "2" => method(:calc_week_2), 
             "3" => method(:calc_week_3),
             "4" => method(:calc_week_4) }
    log = '531_log.yaml'
    lift_log = process_yaml(log)
    valid_choices = ["1", "2", "3", "4", "5", "6", "7", "q", "Q"]
    quit_choices = ["Q", "q", "quit", "Quit"]

    tm_prompt = <<~HEREDOC
    Which lift?
    [1] Squat
    [2] OHP
    [3] Squat II
    [4] OHP II
    [5] Deadlift
    [6] Bench
    [7] All
    [Q]uit
    HEREDOC

    week_prompt = <<~HEREDOC
    What week are you on?
    [1]
    [2]
    [3]
    [4]
    [Q]uit
    HEREDOC

    done = false
    while not done
        puts tm_prompt
        tm = gets.chomp

        if quit_choices.include?(tm)
            done = true
            next
        end

        until valid_choices.include?(tm)
            puts "Please choose a valid option!" 
            puts tm_prompt
            tm = gets.chomp
        end

        puts week_prompt
        week_choice = gets.chomp

        if quit_choices.include?(week_choice)
            done = true
            next
        end

        until valid_choices[0..3].include?(week_choice)
            puts "Please choose a valid option!"
            puts week_prompt
            week_choice = gets.chomp
        end

        if tm == "7"
            for x in lifts.values
                puts "Lift: #{x}"
                puts weeks[week_choice].(lift_log[x])
                puts
            end
            #lifts.each{|x| puts weeks[week_choice].(tm[x])} 
        else
            puts "#{lifts[tm]}: "
            tm = lift_log[ lifts[tm] ]
            
            puts weeks[week_choice].(tm)
            puts
        end #if/else

    end #while loop
        
end #main


main
