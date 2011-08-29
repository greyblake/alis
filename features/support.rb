require 'rubygems'
require 'aruba/cucumber'
require 'tmpdir'

ALIS_ROOT     = File.expand_path File.join(File.dirname(__FILE__), '..')
ALIS_USER_DIR = Dir.mktmpdir

require File.join(ALIS_ROOT, 'lib', 'alis')

Alis.env = :cucumber
ENV['ALIS_ENV'] = "cucumber"


ENV['ALIS_USER_DIR'] = ALIS_USER_DIR
ENV['PATH'] = "#{ALIS_ROOT}/bin:" + ENV['PATH']
ENV['PATH'] = "#{ALIS_USER_DIR}/bin:" + ENV['PATH']

Alis.install!(false)

# for debug
#puts "export ALIS_USER_DIR=#{ALIS_USER_DIR}"
#puts "export ALIS_ENV=cucumber"
#puts ALIS_USER_DIR
