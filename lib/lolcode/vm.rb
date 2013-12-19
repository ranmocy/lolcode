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
      end.join(';')

      puts "[INFO] Ruby code: #{ruby_line}" if self.verbose

      self.buffer << ruby_line
      return if open_block?

      res = nil
      begin
        puts "[INFO] Eval code: #{self.buffer}" if self.verbose
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
      # line.gsub!(/\bOBTW\b/, '\n=begin\n') # multiline comments begin
      # multiline comments begin
      line.gsub!(/\bOBTW\b/) do |s|
        self.block_level += 1
        "\n=begin\n"
      end
      # multiline comments end
      line.gsub!(/\bTLDR\b/) do |s|
        self.block_level -= 1
        "\n=end\n"
      end

      line.gsub!(/\bVISIBLE\b/, 'puts')
      line.gsub!(/\bINVISIBLE\b/, 'warn')

      # Varible assignment
      line.gsub!(/\bI\s+HAS\s+A\s+(\w+)\s+ITZ\s+([\"\w]+)/) do |s|
        m = /\bI HAS A (\w+) ITZ ([\"\w]+)/.match s
        case type_of(m[2])
        when :symbol
          "@#{m[1]} = @#{m[2]}"
        else
          "@#{m[1]} = #{m[2]}"
        end
      end
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

    def type_of string
      return :string if string =~ /^\"(.*)\"$/
      return :int if string =~ /^[0-9]+$/
      return :symbol if string =~ /^\w+$/
      return :untyped
    end

  end
end
