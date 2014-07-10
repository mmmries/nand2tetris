require 'thor'
require 'pathname'
module VmTranslator
  class CLI < Thor
    desc "translate_file VM_FILE", "translate a .vm file into a .asm file"
    def translate_file(vm_file)
      vm_file = Pathname.new(vm_file)
      asm_file = vm_file.sub(".vm",".asm")
      assemblies = VmTranslator.translate_file(vm_file)
      asm = assemblies.join("\n") + "\n"
      File.open(asm_file, 'w') do |f|
        f.write(asm)
      end
      puts "wrote #{asm_file}"
    end

    desc "translate_dir VM_DIR", "translate a directory of .vm files and generate a single .asm file"
    def translate_dir(dirname)
      dir = Pathname.new(dirname)
      assemblies = VmTranslator.translate_dir(dir)
      asm = assemblies.join("\n") + "\n"
      asm_file = dir.join( "#{dir.basename}.asm" )
      File.open(asm_file, 'w') do |f|
        f.write(asm)
      end
      puts "wrote #{asm_file}"
    end
  end
end
