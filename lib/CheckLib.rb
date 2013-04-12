require 'yaml'
require 'CheckLib/Bash'
require 'CheckLib/Python'
require 'CheckLib/Ruby'

module CheckLib

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

  def render(file)
    self.reset_indent
    check = YAML::load(File.open(file))
    result = self.open_function(check['name'])+"\n"
    if check.has_key?('regex')
      result += self.regex(@input_var, check['regex'])+"\n"
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
    end
    result += self.return_success+"\n"
    result += self.close_function+"\n"
    result
  end

end
