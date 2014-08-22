# encoding: utf-8

# require 'rubygems'
# require 'tempfile'
# require 'pathname'
# require 'test/unit'

# require 'shoulda'
# require 'mocha'
# require 'bourne'

# require 'active_record'
# require 'active_record/version'
# require 'active_support'
# require 'active_support/core_ext'
# require 'mime/types'
# require 'pathname'
# require 'ostruct'
# require 'pry'

ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))


def fixture_file(filename)
  File.join(File.dirname(__FILE__), 'fixtures', filename)
end
