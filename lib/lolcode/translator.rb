module Lolcode
  module Translator

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

      line.gsub!(/\bVISIBLE\s+([\"\w]+)/) do |s|
        m = /\bVISIBLE\s+([\"\w]+)/.match s
        case type_of(m[1])
        when :symbol
          "puts @#{m[1]}"
        else
          "puts #{m[1]}"
        end
      end
      line.gsub!(/\bINVISIBLE\s+([\"\w]+)/) do |s|
        m = /\bINVISIBLE\s+([\"\w]+)/.match s
        case type_of(m[1])
        when :symbol
          "warn @#{m[1]}"
        else
          "warn #{m[1]}"
        end
      end

      # Varible assignment
      line.gsub!(/\bI\s+HAS\s+A\s+(\w+)\s+ITZ\s+([\"\w]+)/) do |s|
        m = /\bI\s+HAS\s+A\s+(\w+)\s+ITZ\s+([\"\w]+)/.match s
        case type_of(m[2])
        when :symbol
          "@#{m[1]} = @#{m[2]}"
        else
          "@#{m[1]} = #{m[2]}"
        end
      end
      line.gsub!(/\bI\s+HAS\s+A\s+(\w+)/, '@\1 = nil')

      # TODO: Library
      line.gsub!(/\bCAN\s+HAS\s+(\w+)/, '# require \'\1\'')

      return line
    end

  end
end
