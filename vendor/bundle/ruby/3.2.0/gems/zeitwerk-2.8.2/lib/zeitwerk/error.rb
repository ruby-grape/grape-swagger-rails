# frozen_string_literal: true

module Zeitwerk
  class Error < StandardError
  end

  class ReloadingDisabledError < Error
    #: () -> void
    def initialize
      super("can't reload, please call loader.enable_reloading before setup")
    end
  end

  class NameError < ::NameError
  end

  class SetupRequired < Error
    #: () -> void
    def initialize
      super('please, finish your configuration and call Zeitwerk::Loader#setup once all is ready')
    end
  end

  class ConflictingNamespaceDefinitionError < Error
    #: (String, location: String?, conflicting_file: String) -> void
    def initialize(cpath, location:, conflicting_file:)
      if location
        super("conflicting namespace definition for #{cpath}: #{conflicting_file} conflicts with #{location}")
      else
        super("conflicting namespace definition for #{cpath}: #{conflicting_file} conflicts with an already defined namespace")
      end
    end
  end
end
