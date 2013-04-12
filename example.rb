require 'lib/CheckLib'

puts "\nGenerating bash code...\n"
puts CheckLib::Bash.render('checks/ip4.yml')

puts "\nGenerating ruby code...\n"
puts CheckLib::Ruby.render('checks/ip4.yml')

puts "\nGenerating python code...\n"
puts CheckLib::Python.render('checks/ip4.yml')
