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
    assemblies
  end

  def self.translate_dir(dir)
    file_assemblies = Dir[dir.join("*.vm")].map do |vm_file|
      translate_file(vm_file)
    end
    assemblies = [preamble] + file_assemblies
    assemblies.flatten!
    assemblies.compact!
    assemblies
  end

  def self.preamble
    %w(@256 D=A @SP M=D)
  end
end
