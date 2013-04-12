module Sertify
  module Bash
    extend Sertify
    extend self

    @indent_str = '    '
    @indent_lvl = 0
    @input_var = '1'
    @chunk_var = 'CHUNK'
    @chunk_count_var = 'CHUNK_COUNT'

    def open_function(name)
      self.indent_more "function is_#{name}() {"
    end

    def close_function
      "}"
    end

    def regex(var_name, regex)
      self.indent "[[ \"$#{var_name}\" =~ #{regex} ]] || return 1"
    end

    def open_chunk_loop(split_by)
      result = self.indent "#{@chunk_count_var}=0\n"
      result += self.indent_more "for #{@chunk_var} in ${#{@input_var}//#{split_by}/ }; do"
      result
    end

    def close_chunk_loop
      result = self.indent "let #{@chunk_count_var}++\n"
      result += self.indent_less "done"
      result
    end

    def open_chunk_iter_item(iter)
      self.indent_more "if [ $#{@chunk_count_var} == #{iter} ]; then"
    end

    def close_chunk_iter_item
      self.indent_less "fi"
    end

    def min(var_name, min)
      self.indent "[ $#{var_name} -ge #{min} ] || return 1"
    end

    def max(var_name, max)
      self.indent "[ $#{var_name} -le #{max} ] || return 1"
    end

    def min_len(var_name, min_len)
      self.indent "[ ${##{var_name}} -ge #{min_len} ] || return 1"
    end

    def max_len(var_name, max_len)
      self.indent "[ ${##{var_name}} -le #{max_len} ] || return 1"
    end

    def return_success
      self.indent "return 0"
    end
  end
end
