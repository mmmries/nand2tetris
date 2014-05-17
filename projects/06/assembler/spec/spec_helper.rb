require 'bundler/setup'
require 'rspec/given'

RSpec.configure do |c|
  c.color = true
  c.order = :rand
end

def fixture(basename)
  pathname = File.join(File.dirname(__FILE__),'fixtures',basename)
  File.read(pathname)
end
