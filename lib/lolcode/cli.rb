require 'optparse'
require_relative 'vm'

module Lolcode
  class CLI
    attr_accessor :files, :options

    def initialize
      self.options = {}

      OptionParser.new do |opts|
        opts.banner =
<<-banner
Welcome to Lolcode.
When file is given it is a script excutor, otherwise it's a interpretor.
Usage: lolcode [options] [file]
banner

        opts.on("-v", "Run verbosely") do |v|
          self.options[:verbose] = v
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit 1
        end

        self.files = opts.permute(ARGV) # rest args in ARGV
      end.parse!

      if self.files.empty?
        interpretor
      else
        excutor
      end
    end


    private

    def interpretor
      puts "Welcome to use LOLCODE interpretor."
      vm = VM.new(self.options)
      print "(-o-)> "
      while line = readline
        puts "=> #{vm.run(line) || 'nil'}"
        puts "I'm awake!" if line =~ /^HAI\b/
        puts "Good night!" if line =~ /^KTHXBYE\b/
        print vm.started? ? "(lol)> " : "(-o-)> "
      end
    end

    def excutor
      files.each do |filename|
        vm = VM.new(self.options)
        File.open(filename).readlines.each do |line|
          vm.run(line)
        end
        vm.flush
      end
    end

  end
end
