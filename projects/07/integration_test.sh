#!/usr/bin/env ruby
root = File.dirname(__FILE__)
test_files = Dir["#{root}/**/*.tst"].reject do |test_file|
  test_file.include?("VME")
end.sort.reverse

test_files.each do |test_file|
  print "Running #{test_file} :: "
  output = `CPUEmulator.sh #{File.absolute_path(test_file)}`
  if $?.success?
    puts "[SUCCESS]"
  else
    puts output
  end
end
