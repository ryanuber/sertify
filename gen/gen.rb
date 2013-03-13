require 'yaml'

check = YAML::load(File.open('ip4.yml'))

####
# BASH
####
puts "function is_#{check['name']}() {\n"
puts "    [[ \"$1\" =~ #{check['regex']} ]] || return 1\n"
if check.has_key?('bash')
  check['bash'].split("\n").each do |line|
    puts "    #{line}\n"
  end
end
puts "    return 0\n}\n"


####
# PYTHON
####
puts "def is_#{check['name']}(input):\n"
puts "    if match('#{check['regex']}', input) == None:\n"
puts "        return False\n"
if check.has_key?('python')
  check['python'].split("\n").each do |line|
    puts "    #{line}\n"
  end
end
puts "    return True\n"


####
# RUBY
####
puts "def is_#{check['name']}(input)\n"
puts "  return false if not /#{check['regex']}/.match(input)\n"
if check.has_key?('ruby')
  check['ruby'].split("\n").each do |line|
    puts "  #{line}\n"
  end
end
puts "  return true\nend\n"
