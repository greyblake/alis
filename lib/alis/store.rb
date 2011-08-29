require 'yaml'
require 'singleton'

module Alis
  class Store
    include Singleton

    def initialize
      @store_file = Alis.store_file
      @data = FileTest.exists?(@store_file) ? YAML.load_file(@store_file) : {}
      @alias_cache = {}
      @cmd_cache = {}
    end

    def save!
      File.open(@store_file, 'w'){ |f| YAML.dump(@data, f)}
    end

    def get_alias(cmd, params)
      @alias_cache[[cmd, params]] ||= fetch_alias(cmd, params)
    end

    def get_cmd(name)
      @cmd_cache[name] ||= fetch_cmd(name)
    end

    def find_matched_alias(cmd, params_and_args)
      return nil unless @data[cmd]
      @data[cmd].keys.sort_by(&:size).reverse.each do |prms|
        first_params = params_and_args[0...(prms.size)]
        return get_alias(cmd, prms) if first_params == prms
      end
      nil
    end

    def set_alias(cmd, params, exe, tail)
      @data[cmd] ||= {}
      @data[cmd][params] = {:exe => exe, :tail => tail}
    end

    def remove_alias(cmd, params)
      @data[cmd] && @data[cmd].delete(params)
    end

    def remove_cmd(cmd)
      @data.delete(cmd)
    end

    def remove_all
      @data = {}
    end

    def has_cmd?(cmd)
      !!@data[cmd]
    end


    def to_s
      cols  = [:alias, :exe, :tail]

      # alises to hash
      aliases = @data.map do |cmd, cmd_hash|
        cmd_hash.map do |params, opts| 
          aliaz = "#{cmd} #{params.join(' ')}"
          {:alias => aliaz, :exe => opts[:exe], :tail => opts[:tail]}
        end
      end.flatten

      # add headers
      aliases.unshift({:alias => "ALIAS", :exe => "EXECUTE", :tail => "TAIL"})
      width = cols.inject({}) do |h, col|

        h.merge({col => aliases.map{|a| a[col].size}.max})
      end

      aliases.map do |a|
        cols.map{|col| a[col].ljust(width[col]) }.join(" " * 5)
      end.join("\n")
    end


    private

    def fetch_alias(cmd, params)
      prms = @data[cmd] && @data[cmd][params]
      return nil unless prms
      Alias.new(cmd, params, prms[:exe], prms[:tail])
    end

    def fetch_cmd(name)
      return nil unless @data[name]
      cmd = Cmd.new(name)
      @data[name].each do |alias_data|
        alias_params = alias_data.first
        cmd.aliases << get_alias(name, alias_params)
      end
      cmd
    end
    
  end
end
