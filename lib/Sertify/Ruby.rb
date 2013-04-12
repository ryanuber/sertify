module Sertify
  module Ruby
    extend Sertify
    extend self

    @indent_str = '  '
    @indent_lvl = 0
    @input_var = 'input'
    @chunk_var = 'chunk'
    @chunk_count_var = 'chunk_count'

    def open_function(name)
      self.indent_more "def is_#{name}(input)"
    end

    def close_function
      "end"
    end

    def regex(var_name, regex)
      self.indent "return false if not /#{regex.gsub('/', '\/')}/.match(#{var_name})"
    end

    def open_chunk_loop(split_by)
      result = self.indent "#{@chunk_count_var} = 0\n"
      result += self.indent_more "input.split('#{split_by}').each do |chunk|"
      result
    end

    def close_chunk_loop
      result = self.indent "#{@chunk_count_var} += 1\n"
      result += self.indent_less "end"
      result
    end

    def open_chunk_iter_item(iter)
      self.indent_more "if #{@chunk_count_var} == #{iter}"
    end

    def close_chunk_iter_item
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
