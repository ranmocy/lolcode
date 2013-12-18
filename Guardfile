require 'colorize'

guard :shell do
  watch(/lib\/(.*)\.rb$/) do |m|
    Dir['test/*.lol'].each do |test|
      puts "Run #{test}:".yellow
      puts `bin/lolcode -v #{test}`
    end
    puts "Test done."
  end
end
