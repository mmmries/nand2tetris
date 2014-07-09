require 'bundler/setup'
require 'vm_translator'
require 'rspec'

RSpec.configure do |c|
  c.color = true
  c.order = :rand
end

def fixture_contents(relname)
  File.read(fixture_path(relname))
end

def fixture_path(relname)
  File.join(File.dirname(__FILE__),'fixtures', relname)
end
