module Lolcode
  class VM

    attr_accessor :vars, :started, :verbose

    def initialize(options={})
      halt
      self.verbose = options[:verbose] || false
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
      puts "[INFO] Now LOLCODE VM is started" if self.verbose
    end

    def halt
      self.started = false
      puts "[INFO] Now LOLCODE VM is halted" if self.verbose
    end

    def started?
      self.started
    end

  end
end
