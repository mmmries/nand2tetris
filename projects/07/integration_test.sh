#!/usr/bin/env ruby
require 'pathname'

test_files = []
if ARGV.empty?
  root = File.dirname(__FILE__)
  test_files = Dir["#{root}/**/*.tst"].reject do |test_file|
    test_file.include?("VME")
  end.map do |test_file|
    Pathname.new(test_file)
  end
else
  test_files = ARGV
end

test_files.each do |test_file|
  vm_file = test_file.sub('.tst','.vm')
  asm_file = test_file.sub('.tst','.asm')
  `./vm_translator/bin/vm_translator translate #{vm_file}`
  `Assembler.sh #{File.absolute_path(asm_file)}`

  print "Running #{test_file} :: "
  output = `CPUEmulator.sh #{File.absolute_path(test_file)}`
  if $?.success?
    puts "[SUCCESS]"
  else
    puts output
  end
end
