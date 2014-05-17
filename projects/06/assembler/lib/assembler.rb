require 'assembler/parser'
module Assembler
  def self.assemble(assembly)
    p = Parser.new(assembly)
    p.commands.inject("") do |str, command|
      str << command.binary
      str << "\n"
    end
  end
end
