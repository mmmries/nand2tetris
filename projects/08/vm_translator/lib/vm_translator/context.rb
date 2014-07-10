module VmTranslator
  class Context
    attr_reader :basename, :function

    def initialize(basename, function)
      @basename = basename
      @function = function
    end
  end
end
