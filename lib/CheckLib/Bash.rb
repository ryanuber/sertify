module CheckLib
  module Bash
    extend CheckLib
    extend self

    @indent_str = '    '
    @indent_lvl = 0
    @input_var = '1'
    @chunk_var = 'CHUNK'

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
      self.indent_more "for chunk in ${1//#{split_by}/ }; do"
    end

    def close_chunk_loop
      self.indent_less "done"
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
