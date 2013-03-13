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

    def open_function(name)
      "function is_#{name}() {"
    end

    def close_function
      "}"
    end

    def regex(var_name, regex)
      self.indent "[[ \"$#{var_name}\" =~ #{regex} ]] || return 1"
    end

    def open_chunk_loop(split_by)
      @indent_lvl += 1
      result = self.indent "for chunk in ${1//#{split_by}/ }; do"
      @indent_lvl += 1
      result
    end

    def close_chunk_loop
      @indent_lvl -= 1
      self.indent "done"
    end

    def min(var_name, min)
      self.indent "[ $#{var_name} -ge #{min} ] || return 1"
    end

    def max(var_name, max)
      self.indent "[ $#{var_name} -le #{max} ] || return 1"
    end

    def return_success
      self.indent "return 0"
    end
  end
end

fn = CheckIt::Bash.new

check = YAML::load(File.open('ip4.yml'))
puts fn.open_function(check['name'])+"\n"
if check.has_key?('regex')
  puts fn.regex('1', check['regex'])+"\n"
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
  puts fn.close_chunk_loop+"\n"
  puts fn.return_success+"\n"
  puts fn.close_function+"\n"
end










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
