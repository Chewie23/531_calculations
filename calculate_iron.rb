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

    log = '531_log.yaml'
    lift_log = process_yaml(log)
    valid_choices = ["1", "2", "3", "4", "5", "6"]
    quit_choices = ["Q", "q", "quit", "Quit"]

    tm_prompt = <<~HEREDOC
    Which lift?
    [1] Squat
    [2] OHP
    [3] Squat II
    [4] OHP II
    [5] Deadlift
    [6] Bench
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

        case
        when tm == "1"
            tm = lift_log[:Squat]
        when tm == "2"
            tm = lift_log[:OHP]
        when tm == "3"
            tm = lift_log[:SquatII]
        when tm == "4"
            tm = lift_log[:OHPII]
        when tm == "5"
            tm = lift_log[:Deadlift]
        when tm == "6"
            tm = lift_log[:Bench]
        end

        puts week_prompt
        week = gets.chomp

        if quit_choices.include?(week)
            done = true
            next
        end

        until valid_choices[0..3].include?(week)
            puts "Please choose a valid option!"
            puts week_prompt
            week = gets.chomp
        end

        #TODO
        #Refactor. I am definitely repeating myself here
        case
        when week == "1"
            puts "\n#{calc_week_1(tm)}"
        when week == "2"
            puts "\n#{calc_week_2(tm)}"
        when week == "3"
            puts "\n#{calc_week_3(tm)}"
        when week == "4"
            puts "\n#{calc_week_4(tm)}"
        end #case  

    end #while loop
        
end #main


main
