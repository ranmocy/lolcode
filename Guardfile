require 'colorize'

guard :shell do
  watch(/lib\/(.*)\.rb$/) do |m|
    all_passed = true
    Dir['test/*.lol'].each do |test|
      print "Run #{test}: ".yellow

      res = `bin/lolcode #{test}`
      ans = File.open(test.gsub('.lol', '.txt')).read

      if res == ans
        puts "passed".green
      else
        puts "\nexpected:".yellow
        puts ans
        puts "gotten:".yellow
        puts res
        puts "DEBUG:".yellow
        puts `bin/lolcode -v #{test}`
        all_passed = false
      end
    end
    n 'LOLCODE', '', all_passed ? :success : :failed
    nil
  end
end
