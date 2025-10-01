# We want to run these tests to simulate a production environment
# This is different to how running tests normally works.
ENV['JIKI_ENV'] = 'production'

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "jiki-config"

gem 'minitest'
require "minitest/autorun"
require "minitest/unit"
require "mocha/minitest"
