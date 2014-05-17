require 'assembler/command'
require 'assembler/computation'
require 'assembler/address'

module Assembler
  class Parser
    attr_reader :commands

    def initialize(assembly)
      @commands = []
      parse(assembly)
    end

    private

    def parse(assembly)
      lines = assembly.split("\n")
      lines.map(&:chomp!).each do |line|
        next if line.start_with? "//"
        next if line.empty?
        @commands << Command.build(line)
      end
    end
  end
end
