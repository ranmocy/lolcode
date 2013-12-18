require 'ostruct'
require 'optparse'
require_relative 'vm'

module Lolcode
  class CLI
    attr_accessor :files, :verbose

    def initialize
      OptionParser.new do |opts|
        opts.banner =
<<-banner
Welcome to Lolcode.
When file is given it is a script excutor, otherwise it's a interpretor.
Usage: lolcode [options] [file]
banner

        opts.on("-v", "Run verbosely") do |v|
          self.verbose = v
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
      vm = VM.new
      print "=>"
      while line = readline
        vm.run(line)
        print "=>"
      end
    end

    def excutor
      files.each do |filename|
        vm = VM.new
        File.open(filename).readlines.each do |line|
          vm.run(line)
        end
      end
    end

  end
end
