#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '../lib/alis')

cmd = $0.split('/').last
params = ARGV || []

if al = Alis.store.find_matched_alias(cmd, params)
  al.init_args_from_passed_params(params)
  al.execute
elsif origin_cmd_path = Alis.full_path_for_cmd(cmd)
  system "#{origin_cmd_path} #{params.join(' ')}"
end
