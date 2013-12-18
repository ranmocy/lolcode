module Lolcode
  class MissingVars < StandardError

    def initialize(var_name = nil)
      if var_name
        super("[ERROR] Varible #{var_name} is missing!")
      else
        super
      end
    end

  end
end
