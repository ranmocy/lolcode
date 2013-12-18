require 'colorize'

guard :shell do
  watch(/lib\/(.*)\.rb$/) do |m|
    puts "bin/lolcode file:\n".yellow + `bin/lolcode Gemfile`
  end
end
