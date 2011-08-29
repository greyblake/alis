module Alis
  class Alias
    attr_writer :args
    attr_reader :params

    def self.get(cmd_name, params)
      Alis.store.get_alias(cmd_name, params)
    end

    def initialize(cmd_name, params, exe, tail)
      @cmd_name, @params, @exe, @tail = cmd_name, params, exe, tail
      @args = []
    end

    def cmd
      Alis.store.get_cmd(@cmd_name)
    end

    def init_args_from_passed_params(prms)
      @args = prms[@params.size..-1]
    end

    def execute
      exes = @exe.split(/\s/)
      exes = [Alis.full_path_for_cmd(exes[0])] + exes[1..-1]
      exe = exes.join(' ')
      system "#{exe} #{@args.join(' ')} #{@tail}"
    end

    def remove
      @cmd.remove_alias(@params)
    end

  end
end
