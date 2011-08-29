module Alis
  class Cmd

    attr_accessor :aliases

    class << self
      def get(name)
        Alis.store.get_cmd(name)
      end

      def get_or_create(name)
        cmd = get(name) || Cmd.new(name)
        cmd.create_bin! unless cmd.has_bin?
        cmd
      end
    end


    def initialize(name)
      @name = name.strip
      @store = Alis.store
      @aliases = []
    end

    def has_bin?
      FileTest.executable?(bin_path)
    end

    def create_bin!
      FileUtils.mkdir_p(Alis.bin_dir) unless Dir.exists?(Alis.bin_dir)

      FileUtils.cp(Alis.tpl_path, bin_path)
      FileUtils.chmod 0755, bin_path
    end

    def bin_path
      File.join(Alis.bin_dir, @name)
    end

    def remove
      @store.remove_cmd(@name)
      FileUtils.rm(bin_path) if has_bin?
    end

    def add_alias(params, exe, tail)
      @store.set_alias(@name, params, exe, tail)
    end

    def remove_alias(params)
      if @aliases.size == 1 && @aliases[0] && @aliases[0].params == params
        remove
      else
        @store.remove_alias(@name, params)
      end
    end

  end
end
