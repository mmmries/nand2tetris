require 'thor'
require 'pathname'
module VmTranslator
  class CLI < Thor
    desc "translate VM_FILE", "translate a .vm file into a .asm file"
    def translate(vm_file)
      vm_file = Pathname.new(vm_file)
      asm_file = vm_file.sub(".vm",".asm")
      asm = VmTranslator.translate(File.read(vm_file))
      File.open(asm_file, 'w') do |f|
        f.write(asm)
      end
      puts "wrote #{asm_file}"
    end
  end
end
