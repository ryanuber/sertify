require 'yaml'

class CheckIt
  class Bash
    def initialize
      @indent_str = '    '
      @indent_lvl = 0
    end

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

  class Ruby
    def initialize
      @indent_str = '  '
      @indent_lvl = 0
    end

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
      self.indent "return false if #{var_name} < #{min}"
    end

    def max(var_name, max)
      self.indent "return false if #{var_name} > #{max}"
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

fn = CheckIt::Ruby.new

check = YAML::load(File.open('checks/mac.yml'))
puts fn.open_function(check['name'])+"\n"
if check.has_key?('regex')
  puts fn.regex('1', check['regex'])+"\n"
end
if check.has_key?('min')
  puts fn.min('1', check['min'])+"\n"
end
if check.has_key?('max')
  puts fn.max('1', check['max'])+"\n"
end
if check.has_key?('min_len')
  puts fn.min_len('1', check['min_len'])+"\n"
end
if check.has_key?('max_len')
  puts fn.max_len('1', check['max_len'])+"\n"
end

if check.has_key?('chunks') and check['chunks'].has_key?('split_by')
  puts fn.open_chunk_loop(check['chunks']['split_by'])+"\n"
  if check['chunks'].has_key?('regex')
    puts fn.regex('chunk', check['chunks']['regex'])+"\n"
  end
  if check['chunks'].has_key?('min')
    puts fn.min('chunk', check['chunks']['min'])+"\n"
  end
  if check['chunks'].has_key?('max')
    puts fn.max('chunk', check['chunks']['max'])+"\n"
  end
  if check['chunks'].has_key?('min_len')
    puts fn.min_len('chunk', check['chunks']['min_len'])+"\n"
  end
  if check['chunks'].has_key?('max_len')
    puts fn.max_len('chunk', check['chunks']['max_len'])+"\n"
  end
  puts fn.close_chunk_loop+"\n"
end
puts fn.return_success+"\n"
puts fn.close_function+"\n"










#if check.has_key?('bash')
#  check['bash'].split("\n").each do |line|
#    puts "    #{line}\n"
#  end
#end
#puts "    return 0\n}\n"


####
# PYTHON
####
#puts "def is_#{check['name']}(input):\n"
#puts "    if match('#{check['regex']}', input) == None:\n"
#puts "        return False\n"
#if check.has_key?('python')
#  check['python'].split("\n").each do |line|
#    puts "    #{line}\n"
#  end
#end
#puts "    return True\n"


####
# RUBY
####
#puts "def is_#{check['name']}(input)\n"
#puts "  return false if not /#{check['regex']}/.match(input)\n"
#if check.has_key?('ruby')
#  check['ruby'].split("\n").each do |line|
#    puts "  #{line}\n"
#  end
#end
#puts "  return true\nend\n"
