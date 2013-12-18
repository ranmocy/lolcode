module Lolcode
  class VM

    attr_accessor :vars, :started, :verbose

    def initialize(options={})
      halt
      self.verbose = options[:verbose]
      self.vars = {}
    end

    def run(line)
      line.gsub!(/\bBTW\b.*/, '') # remove BTW comments

      (start; return) if line =~ /HAI\b.*/    # start VM
      (halt; return) if line =~ /KTHXBYE\b.*/ # halt VM
      return unless started?

      puts "TODO - should run line #{line}"
    end


    private

    def start
      self.started = true
    end

    def halt
      self.started = false
    end

    def started?
      self.started
    end

  end
end
