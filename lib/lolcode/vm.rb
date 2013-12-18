require_relative 'errors'

module Lolcode
  class VM

    attr_accessor :vars, :started, :verbose

    def initialize(options={})
      halt
      self.verbose = options[:verbose] || false
      self.vars = {}
    end

    def run(line)
      puts "[INFO] Run line: #{line}" if self.verbose

      line.gsub!(/\bBTW\b.*/, '') # remove BTW comments

      (start; return) if line =~ /^HAI\b.*/    # start VM
      (halt; return) if line =~ /^KTHXBYE\b.*/ # halt VM
      return unless started?

      (visible $1; return) if line =~ /^VISIBLE\s+(.*)$/

      puts "TODO - should run line #{line}"
    end


    private

    def start
      self.started = true
      puts "[INFO] Now LOLCODE VM is started" if self.verbose
    end

    def halt
      self.started = false
      puts "[INFO] Now LOLCODE VM is halted" if self.verbose
    end

    def started?
      self.started
    end

    def visible content
      if content =~ /^\"(.*)\"$/
        puts $1
      elsif self.vars.include? content
        puts self.vars[content]
      else
        raise Lolcode::MissingVars, content
      end
    end
  end
end
