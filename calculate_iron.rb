#
#TODO
#Have an automated way to increase TM. Maybe on user's choice?
#   I personally like to automate
#   Maybe have it write to YAML file what week? Then have it increase? May need
#   to work on that
#

require 'yaml'

class CalculateIron
    def initialize
        @add_5_arr  = [:OHP, :OHPII, :Bench]
        @log_file = '531_log.yaml'

        #Need to keep in Hash, so we can access the individual lifts when getting the "tm"
        @lifts = {"1" => :Squat, "2" => :OHP,
                 "3" => :SquatII, "4" =>:OHPII,
                 "5" => :Deadlift, "6" => :Bench}
        @weeks = {"1" => method(:calc_week_1),
                 "2" => method(:calc_week_2),
                 "3" => method(:calc_week_3),
                 "4" => method(:calc_week_4) }

        #This reads the YAML file into a Hash
        @lift_log = read_yaml()

        #This can definitely use some cleaning up
        @valid_choices = ["1", "2", "3", "4", "5", "6",
                          "7", "8", "9", "q", "Q"]
        @quit_choices = ["Q", "q"]

        @tm_prompt = <<~HEREDOC
        Which lift?
        [1] Squat
        [2] OHP
        [3] Squat II
        [4] OHP II
        [5] Deadlift
        [6] Bench
        [7] All
        [8] Preview next cycle
        [9] Increase TM
        [Q]uit
        HEREDOC

        @week_prompt = <<~HEREDOC
        What week are you on?
        [1]
        [2]
        [3]
        [4]
        HEREDOC
    end


    def read_yaml()
        #Gives back a Hash, based on the YAML file
        y_file = YAML.load_file(@log_file)
        return y_file
    end

    def write_yaml()
        #This assumes we did all the necessary changes to @lift_log
        File.open(@log_file, 'w') { |f| YAML.dump(@lift_log, f) }
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

    def calc_warm_up(tm)
        return [0.40, 0.50, 0.60].map!{|x| get_multiple_of_5(x*tm)}
    end

    def preview_next_cycle(week_choice)
        #Fun Ruby "for loop" (aka the do/end block)
        add_to_tm()
        get_all_lifts(week_choice)

        #resetting the lift log since this is a preview
        @lift_log = read_yaml()
    end

    def get_all_lifts(week_choice)
        for x in @lifts.values
            puts "Lift: #{x}"
            puts "Warm up"
            puts calc_warm_up(@lift_log[x])
            puts "\nWork weight"
            puts @weeks[week_choice].(@lift_log[x])
            puts "----------------"
        end
    end

    def add_to_tm()
        @lift_log.each_key do |key|
            if @add_5_arr.include?(key)
            @lift_log[key] += 5
            else
            @lift_log[key] += 10
            end
        end
    end

    def get_week_choice()
        puts @week_prompt
        week_choice = gets.chomp

        until @valid_choices[0..3].include?(week_choice)
            puts "Please choose a valid option!"
            puts @week_prompt
            week_choice = gets.chomp
        end
        return week_choice
    end

    def get_lift_choice()
        puts @tm_prompt
        tm = gets.chomp

        until @valid_choices.include?(tm)
            puts "Please choose a valid option!"
            puts @tm_prompt
            tm = gets.chomp
        end
        if @quit_choices.include?(tm)
            exit 0
        end
        return tm
    end

    def main
        while true
            tm = get_lift_choice()
            if tm == "7"
                week_choice = get_week_choice()
                get_all_lifts(week_choice)
            elsif tm == "8"
                week_choice = get_week_choice()
                preview_next_cycle(week_choice)
            elsif tm == "9"
                #Have to use ".dup" to copy the value, since Ruby will point to the object
                #So if the object changes, the variables pointing to it will change as well
                temp_var = @lift_log.dup
                add_to_tm()
                @lifts.values.each do |lift|
                    puts("Changing #{lift}: #{temp_var[lift]} to be #{@lift_log[lift]}")
                end
                write_yaml()
            else
                week_choice = get_week_choice()
                puts "#{@lifts[tm]}: "
                tm = @lift_log[ @lifts[tm] ]
                puts "Warm up"
                puts calc_warm_up(tm)
                puts "\nWork weight"
                puts @weeks[week_choice].(tm)
                puts "----------------"
            end #if/else
        end #while
    end #main
end #class


c = CalculateIron.new
c.main
