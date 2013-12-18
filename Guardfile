guard :shell do
  watch(/lib\/(.*)\.rb$/) do |m|
    puts
    puts "bin/lolcode:"
    puts `bin/lolcode`
    puts "bin/lolcode -h:"
    puts `bin/lolcode -h`
  end
end
