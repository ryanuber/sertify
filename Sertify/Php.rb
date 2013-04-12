module Sertify
  module Php
    extend Sertify
    extend self

    @indent_str = '    '
    @indent_lvl = 0
    @input_var = 'input'
    @chunk_var = 'chunk'
    @chunk_count_var = 'chunk_count'

    def open_function(name)
      self.indent_more "function is_#{name}($#{@input_var}) {"
    end

    def close_function
      "}"
    end

    def regex(var_name, regex)
      result = self.indent_more "if (preg_match('/#{regex.gsub('/', '\/')}/', $#{var_name}) != 1) {\n"
      result += self.indent "return false;\n"
      result += self.indent_less "}"
      result
    end

    def open_chunk_loop(split_by)
      result = self.indent "$#{@chunk_count_var} = 0;\n"
      result += self.indent_more "foreach (explode('#{split_by}', $#{@input_var}) as $#{@chunk_var}) {"
      result
    end

    def close_chunk_loop
      result = self.indent "$#{@chunk_count_var}++;\n"
      result += self.indent_less "}"
      result
    end

    def open_chunk_iter_item(iter)
      self.indent_more "if ($#{@chunk_count_var} == #{iter}) {"
    end

    def close_chunk_iter_item
      self.indent_less "}"
    end

    def min(var_name, min)
      result = self.indent_more "if ($#{var_name} < #{min}) {\n"
      result += self.indent "return false;\n"
      result += self.indent_less "}"
      result
    end

    def max(var_name, max)
      result = self.indent_more "if ($#{var_name} > #{max}) {\n"
      result += self.indent "return false;\n"
      result += self.indent_less "}"
      result
    end

    def min_len(var_name, min_len)
      result = self.indent_more "if (strlen($#{var_name}) < #{min_len}) {\n"
      result += self.indent "return false;\n"
      result += self.indent_less "}"
      result
    end

    def max_len(var_name, max_len)
      result = self.indent_more "if (strlen($#{var_name}) > #{max_len}) {\n"
      result += self.indent "return false;\n"
      result += self.indent_less "}"
      result
    end

    def return_success
      self.indent "return true;"
    end
  end
end
