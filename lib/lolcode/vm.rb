require_relative 'errors'

module Lolcode
  class VM

    attr_accessor :buffer, :started, :verbose

    def initialize(options={})
      $stdout.sync = true
      $stderr.sync = true

      halt
      reset_buffer
      self.verbose = options[:verbose] || false
    end

    def run(line)
      puts "[INFO] Orig line: #{line}" if self.verbose

      line.gsub!(/\bBTW\b/, ' # ') # BTW comments

      (start; return) if line =~ /^HAI\b.*/    # start VM
      (halt; return) if line =~ /^KTHXBYE\b.*/ # halt VM
      return unless started?

      line.gsub!(/\bVISIBLE\b/, 'puts')
      line.gsub!(/\bINVISIBLE\b/, 'warn')

      # Varible assignment
      line.gsub!(/\bI HAS A (\w+)\b/, '@\1 = nil')

      # TODO: Library
      line.gsub!(/\bCAN HAS (\w+)\b/, '# require \'\1\'')

      puts "[INFO] Ruby code: #{line}" if self.verbose

      self.buffer << line

      begin
        eval self.buffer
        reset_buffer
      rescue
        puts "[ERROR] Exec Error: #{line}"
      end

      $stdout.flush
      $stderr.flush
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

    def reset_buffer
      self.buffer = ""
    end


    def is_string content
      content =~ /^\"(.*)\"$/
    end

  end
end
