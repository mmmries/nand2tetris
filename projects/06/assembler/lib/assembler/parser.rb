require 'assembler/command'
require 'assembler/computation'
require 'assembler/address'
require 'assembler/symbol_table'

module Assembler
  class Parser
    attr_reader :commands, :symbol_table

    def initialize(assembly)
      @commands = []
      @symbol_table = SymbolTable.new
      parse(assembly)
      resolve_symbols
    end

    private

    def add_symbol(symbol)
      symbol_table.add_location_symbol(symbol, commands.size)
    end

    def parse(assembly)
      lines = assembly.split("\n")
      lines.map do |line|
        strip_comment(line)
      end.map(&:strip).reject(&:empty?).each do |line|
        if line.start_with?("(")
          add_symbol(line[1..-2])
        else
          @commands << Command.build(line)
        end
      end
    end

    def resolve_symbols
      commands.select do |command|
        command.is_a?(Address)
      end.each do |command|
        command.resolve(symbol_table)
      end
    end

    def strip_comment(line)
      if idx = line.index("//")
        line = line.slice(0,idx)
      end
      line
    end
  end
end
