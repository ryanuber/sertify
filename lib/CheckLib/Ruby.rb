module CheckLib
  module Ruby
    extend CheckLib
    extend self

    @indent_str = '  '
    @indent_lvl = 0
    @input_var = 'input'
    @chunk_var = 'chunk'

    def open_function(name)
      self.indent_more "def is_#{name}(input)"
    end

    def close_function
      "end"
    end

    def regex(var_name, regex)
      self.indent "return false if not /#{regex}/.match(#{var_name})"
    end

    def open_chunk_loop(split_by)
      self.indent_more "input.split('#{split_by}').each do |chunk|"
    end

    def close_chunk_loop
      self.indent_less "end"
    end

    def min(var_name, min)
      self.indent "return false if #{var_name}.to_i < #{min}"
    end

    def max(var_name, max)
      self.indent "return false if #{var_name}.to_i > #{max}"
    end

    def min_len(var_name, min_len)
      self.indent "return false if #{var_name}.length < #{min_len}"
    end

    def max_len(var_name, max_len)
      self.indent "return false if #{var_name}.length > #{max_len}"
    end

    def return_success
      self.indent "return true"
    end
  end
end
