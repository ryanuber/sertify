require 'yaml'

module CheckIt

  def indent(str)
    (@indent_str * @indent_lvl) + str
  end

  def indent_more(str)
    result = self.indent(str)
    @indent_lvl += 1
    result
  end

  def indent_less(str)
    @indent_lvl -= 1
    self.indent(str)
  end

  def render(file)
    check = YAML::load(File.open(file))
    print self.open_function(check['name'])+"\n"
    if check.has_key?('regex')
      print self.regex(@input_var, check['regex'])+"\n"
    end
    if check.has_key?('min')
      puts self.min(@input_var, check['min'])+"\n"
    end
    if check.has_key?('max')
      puts self.max(@input_var, check['max'])+"\n"
    end
    if check.has_key?('min_len')
      puts self.min_len(@input_var, check['min_len'])+"\n"
    end
    if check.has_key?('max_len')
      puts self.max_len(@input_var, check['max_len'])+"\n"
    end
    if check.has_key?('chunks') and check['chunks'].has_key?('split_by')
      puts self.open_chunk_loop(check['chunks']['split_by'])+"\n"
      if check['chunks'].has_key?('regex')
        puts self.regex(@chunk_var, check['chunks']['regex'])+"\n"
      end
      if check['chunks'].has_key?('min')
        puts self.min(@chunk_var, check['chunks']['min'])+"\n"
      end
      if check['chunks'].has_key?('max')
        puts self.max(@chunk_var, check['chunks']['max'])+"\n"
      end
      if check['chunks'].has_key?('min_len')
        puts self.min_len(@chunk_var, check['chunks']['min_len'])+"\n"
      end
      if check['chunks'].has_key?('max_len')
        puts self.max_len(@chunk_var, check['chunks']['max_len'])+"\n"
      end
      puts self.close_chunk_loop+"\n"
    end
    puts self.return_success+"\n"
    puts self.close_function+"\n"
  end

  module Bash
    extend CheckIt
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

  module Ruby
    extend CheckIt
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

  module Python
    extend CheckIt
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

CheckIt::Bash.render('checks/ip4.yml')
CheckIt::Ruby.render('checks/ip4.yml')
CheckIt::Python.render('checks/ip4.yml')
