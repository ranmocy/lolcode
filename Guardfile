require 'colorize'

guard :shell do
  watch(/lib\/(.*)\.rb$/) do |m|
    puts "Begin test:".green
    puts "bin/lolcode:\n".yellow + `bin/lolcode`
    puts "bin/lolcode -h:\n".yellow + `bin/lolcode -h`
    puts "bin/lolcode -v:\n".yellow + `bin/lolcode -v`
    puts "bin/lolcode file:\n".yellow + `bin/lolcode Gemfile`
  end
end
