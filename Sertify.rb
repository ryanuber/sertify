require 'yaml'
require 'Sertify/Bash'
require 'Sertify/Python'
require 'Sertify/Ruby'
require 'Sertify/Php'

module Sertify

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

  def reset_indent
    @indent_lvl = 0
  end

  def one_of(var_name, regex_list)
    result = ""
    regex_count = 0
    regex_list.each do |regex|
      regex_count += 1
      if regex_count == 1
        result += self.regex_chain(var_name, regex, 'first')+"\n"
      elsif regex_count != regex_list.length
        result += self.regex_chain(var_name, regex, 'middle')+"\n" 
      else
        result += self.regex_chain(var_name, regex, 'end')+"\n"
      end
    end
    result
  end

  def render(file)
    self.reset_indent
    check = YAML::load(File.open(file))
    result = self.open_function(check['name'])+"\n"
    if check.has_key?('regex')
      if check['regex'].kind_of?(Array):
        check['regex'].each do |pattern|
          result += self.regex(@input_var, pattern)+"\n"
        end
      else
        result += self.regex(@input_var, check['regex'])+"\n"
      end
    end

    if check.has_key?('one_of')
      result += self.one_of(@input_var, check['one_of'])
    end

    if check.has_key?('min')
      result += self.min(@input_var, check['min'])+"\n"
    end
    if check.has_key?('max')
      result += self.max(@input_var, check['max'])+"\n"
    end
    if check.has_key?('min_len')
      result += self.min_len(@input_var, check['min_len'])+"\n"
    end
    if check.has_key?('max_len')
      result += self.max_len(@input_var, check['max_len'])+"\n"
    end
    if check.has_key?('chunks') and check['chunks'].has_key?('split_by')
      result += self.open_chunk_loop(check['chunks']['split_by'])+"\n"
      if check['chunks'].has_key?('regex')
        result += self.regex(@chunk_var, check['chunks']['regex'])+"\n"
      end
      if check['chunks'].has_key?('one_of')
        result += self.one_of(@chunk_var, check['chunks']['one_of'])
      end
      if check['chunks'].has_key?('min')
        result += self.min(@chunk_var, check['chunks']['min'])+"\n"
      end
      if check['chunks'].has_key?('max')
        result += self.max(@chunk_var, check['chunks']['max'])+"\n"
      end
      if check['chunks'].has_key?('min_len')
        result += self.min_len(@chunk_var, check['chunks']['min_len'])+"\n"
      end
      if check['chunks'].has_key?('max_len')
        result += self.max_len(@chunk_var, check['chunks']['max_len'])+"\n"
      end
      if check['chunks'].has_key?('by_iter')
        check['chunks']['by_iter'].each do |iter, data|
          result += self.open_chunk_iter_item(iter)+"\n"
          if data.has_key?('regex')
            result += self.regex(@chunk_var, data['regex'])+"\n"
          end
          if data.has_key?('min')
            result += self.min(@chunk_var, data['min'])+"\n"
          end
          if data.has_key?('max')
            result += self.max(@chunk_var, data['max'])+"\n"
          end
          if data.has_key?('min_len')
            result += self.min_len(@chunk_var, data['min_len'])+"\n"
          end
          if data.has_key?('max_len')
            result += self.max_len(@chunk_var, data['max_len'])+"\n"
          end
          result += self.close_chunk_iter_item+"\n"
        end
      end 
      result += self.close_chunk_loop+"\n"
      if check.has_key?('min_chunks')
        result += self.min_chunks(check['min_chunks'])+"\n"
      end 
      if check.has_key?('max_chunks')
        result += self.max_chunks(check['max_chunks'])+"\n"
      end
    end
    result += self.return_success+"\n"
    result += self.close_function+"\n"
    result
  end

end
