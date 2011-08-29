$:.unshift File.expand_path(File.dirname(__FILE__))

require 'fileutils'

require 'alis/cmd'
require 'alis/store'
require 'alis/alias'

module Alis
  class << self

    def store
      Store.instance
    end

    def install!(modify_profile = true)
      if modify_profile
        File.open(profile_path, 'a'){|f| f.puts(extend_path_str)}
      end
      FileUtils.cp_r(lib_path, user_lib_dir)
    end

    def uninstall!
      content = File.read(profile_path) 
      content.sub!(/#{Regexp.quote(extend_path_str)}\n/m, '')
      File.open(profile_path, 'w'){|f| f.write(content)}

      FileUtils.rm_rf(user_lib_dir)
    end

    def installed?
      File.open(profile_path, 'r') do |f| 
        f.each_line do |ln|
          return true if ln =~ /^#{Regexp.quote(extend_path_str)}/
        end
      end
      false
    end

    def full_path_for_cmd(cmd)
      paths = ENV['PATH'].split(':') - [bin_dir]
      paths.each do |path|
        full_path = File.join(path, cmd)
        return full_path if FileTest.executable?(full_path)
      end
      nil
    end

    def extend_path_str
      "export PATH=#{bin_dir}:$PATH"
    end

    def profile_path
      File.join(home_dir, '.bash_profile')
    end

    def bin_dir
      File.join(user_dir, 'bin')
    end

    def store_file
      File.join(user_dir, 'store.yml')
    end

    def user_dir
      @user_dir ||= {:user => File.join(home_dir, '.alis'), :cucumber => ENV['ALIS_USER_DIR']}[env]
    end

    def user_lib_dir
      File.join(user_dir, "lib")
    end

    def home_dir
      ENV['HOME']
    end

    def alis_root_dir
      File.expand_path(File.dirname(__FILE__) + "/..")
    end

    def tpl_path
      File.join(lib_path, 'alis/cmd_template.rb')
    end

    def lib_path
      File.join(alis_root_dir, 'lib')
    end

    def env
      @env ||= (ENV['ALIS_ENV'] && ENV['ALIS_ENV'].to_sym || :user)
    end

    def env=(en)
      en = en.to_sym
      raise "Not allowable value for env" unless [:user, :cucumber].include?(en)
      @env = en
    end

  end
end
