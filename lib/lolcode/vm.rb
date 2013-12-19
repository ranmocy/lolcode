require_relative 'translator'

module Lolcode
  class VM
    include Lolcode::Translator

    attr_accessor :buffer, :block_level, :started, :verbose

    def initialize(options={})
      reset_all
      $stdout.sync = true
      $stderr.sync = true
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

    def started?
      self.started
    end


    private

    def start
      self.started = true
      puts "[INFO] Now LOLCODE VM is started" if self.verbose
    end

    def halt
      reset_all
      puts "[INFO] Now LOLCODE VM is halted" if self.verbose
    end

    def reset_buffer
      self.buffer = ""
    end

    def reset_all
      instance_variables.each { |v| remove_instance_variable(v) }
      self.started = false
      self.block_level = 0
      reset_buffer
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
