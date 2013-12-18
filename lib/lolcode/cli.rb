require 'ostruct'
require 'optparse'

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
      puts 'TODO - should begin a interpretor'
    end

    def excutor
      files.each do |file|
        puts "TODO - should run file #{file}"
      end
    end
  end
end
