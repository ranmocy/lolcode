require_relative 'errors'

module Lolcode
  class VM

    attr_accessor :buffer, :block_level, :started, :verbose

    def initialize(options={})
      $stdout.sync = true
      $stderr.sync = true

      halt
      reset_buffer
      self.block_level = 0
      self.verbose = options[:verbose] || false
    end

    def run(line)
      puts "[INFO] Orig line: #{line}" if self.verbose

      (start; return) if line =~ /^HAI\b.*/    # start VM
      (halt; return) if line =~ /^KTHXBYE\b.*/ # halt VM
      return unless started?

      # TODO: comma in the string shouldn't be splited
      ruby_line = line.split(',').collect do |l|
        translate(l)
      end.join

      puts "[INFO] Ruby code: #{ruby_line}" if self.verbose

      self.buffer << ruby_line
      return if open_block?

      res = nil
      begin
        res = eval self.buffer
        reset_buffer
      rescue
        puts "[ERROR] Exec Error: #{line}"
      end

      $stdout.flush
      $stderr.flush

      res
    end

    # Flush the buffer
    def flush
      run('')
    end

    # Translate to Ruby
    def translate(line)
      line = line.dup

      line.gsub!(/\bBTW\b/, ' # ')         # BTW comments
      line.gsub!(/\bOBTW\b/, '\n=begin\n') # multiline comments begin
      line.gsub!(/\bTLDR\b/, '\n=end\n')   # multiline comments end

      line.gsub!(/\bVISIBLE\b/, 'puts')
      line.gsub!(/\bINVISIBLE\b/, 'warn')

      # Varible assignment
      line.gsub!(/\bI HAS A (\w+) ITZ (\w+)/, '@\1 = \2')
      line.gsub!(/\bI HAS A (\w+)\b/, '@\1 = nil')

      # TODO: Library
      line.gsub!(/\bCAN HAS (\w+)\b/, '# require \'\1\'')

      return line
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


    def open_block?
      self.block_level > 0
    end

    def is_string content
      content =~ /^\"(.*)\"$/
    end

  end
end
