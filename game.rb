require "colorize"
require 'json'


H = 15
W = 40
COLORS = [:blue, :red, :green, :yellow]
HISCRE = "./score.json"
$mon = Array.new(H*W)
$points = 0
$points_to_get
$mainstream
$lives = 9


def counter
        while $points_to_get > 0
                $points_to_get -= 1
                sleep 0.1
        end
end

def init
        print `clear`
        rndmize = Array.new
        COLORS.each do |c| 
            rndmize.push c
            rand(12).times {rndmize.push c}
        end
        $mon = $mon.map {rndmize.sample}
        $points_to_get = 100
        h = Hash.new(0)
        $mon.each{|i| h[i] += 1 }
        while (COLORS - $mon.uniq).length > 1 do
                $mon[rand($mon.length)] = COLORS.sample
        end
        $mainstream = h.min{|a,b| a[1] <=> b[1] }.first.to_s
end

def play
        puts "press ENTER to start"
        gets
        print `clear`
        puts "Can you see the other kids?"
        $mon.each_with_index do |e, i|
                print " ".colorize :background => e
                puts '' if (i+1).%(W).zero?
        end
        cntr = Thread.new {counter}
        puts "Choose a non-mainstream color (#{COLORS.map{|a|a.to_s}.join ', '}):"
        name = gets
        Thread.kill cntr
        print `clear`
        if ($mainstream == name.strip)
               puts "#{$mainstream} is a perfect  hipster-color, you survived"
               $points += $points_to_get
               puts "Now you have #{$points} hipster-points (#{$points_to_get} are new)!"
        else 
               $lives -= 1
               puts "#{name.strip} is too mainstream, you lost one live!"
               puts "A real Hipster would choose #{$mainstream}!"
        end
        puts "You have #{$lives} lives left."
        gets
end

puts "'We all love cats so you have #{$lives} lives!"
gets
while $lives > 0 
        init
        play
end


puts "============================"
puts "You earned #{$points} points."

score = JSON.parse(File.read(HISCRE))
if (score.values.min.nil? || (score.values.min < $points) || score.values.length < 10)
    puts "Enter your Name for the Highscore-List"
    score[gets.strip] = $points
    File.open(HISCRE,"w") do |f|
        f.write(Hash[score.sort_by { |k,v| -v }.first 10].to_json)
        f.close
    end
end
puts
Hash[score.sort_by { |k,v| -v }.first 10].each {|key, value| puts "#{key} -> #{value}" }