require 'bundler/setup'
require 'rspec/given'
require 'pry'

lib_dir = File.join(File.dirname(__FILE__),'..','lib')
$: << lib_dir

RSpec.configure do |c|
  c.color = true
  c.order = :rand
end

def fixture(basename)
  pathname = File.join(File.dirname(__FILE__),'fixtures',basename)
  File.read(pathname)
end
