module CheckLib
  module Python
    extend CheckLib
    extend self

    @indent_str = '    '
    @indent_lvl = 0
    @input_var = 'input'
    @chunk_var = 'chunk'

    def open_function(name)
      result = self.indent_more "def is_#{name}(input):\n"
      result += self.indent "from re import match"
      result
    end

    def close_function
      ""
    end

    def regex(var_name, regex)
      result = self.indent_more "if not match('#{regex}', #{var_name}):\n"
      result += self.indent "return False"
      self.indent_less ""
      result
    end

    def open_chunk_loop(split_by)
      self.indent_more "for #{@chunk_var} in #{@input_var}.split(\"#{split_by}\"):"
    end

    def close_chunk_loop
      self.indent_less ""
    end

    def min(var_name, min)
      result = self.indent_more "if int(#{var_name}) < #{min}:\n"
      result += self.indent "return False"
      self.indent_less ""
      result
    end

    def max(var_name, max)
      result = self.indent_more "if int(#{var_name}) > #{max}:\n"
      result += self.indent "return False"
      self.indent_less ""
      result
    end

    def min_len(var_name, min_len)
      result = self.indent_more "if len(#{var_name}) < #{min_len}:\n"
      result += self.indent "return False"
      self.indent_less ""
      result
    end

    def max_len(var_name, max_len)
      result = self.indent_more "if len(#{var_name}) > #{max_len}:\n"
      result += self.indent "return False"
      self.indent_less ""
      result
    end

    def return_success
      self.indent "return True"
    end
  end
end
