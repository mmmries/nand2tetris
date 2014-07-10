require "vm_translator/version"
require "vm_translator/cli"
require "vm_translator/context"

require 'vm/instruction'

module VmTranslator
  def self.translate_file(filename)
    context = Context.new(File.basename(filename,'.vm'), nil)
    bytecode = File.read(filename)
    assemblies = bytecode.lines.map do |line|
      VM::Instruction.build_for(line.chomp, context).commented_assemblies
    end
    assemblies.flatten!
    assemblies.compact!
    assemblies.join("\n") + "\n"
  end
end
