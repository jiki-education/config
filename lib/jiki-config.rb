require "zeitwerk"
loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.inflector.inflect("jiki-config" => "JikiConfig")
loader.inflector.inflect("version" => "VERSION")
loader.setup

require 'aws-sdk-dynamodb'
require 'aws-sdk-secretsmanager'
require 'mandate'
require 'ostruct'
require 'json'

module ::JikiConfig
end
