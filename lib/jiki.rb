module Jiki
  class ConfigError < RuntimeError; end

  def self.env
    @env ||= JikiConfig::DetermineEnvironment.()
  end

  def self.config
    @config ||= JikiConfig::RetrieveConfig.()
  end

  def self.secrets
    @secrets ||= JikiConfig::RetrieveSecrets.()
  end

  def self.dynamodb_client
    Aws::DynamoDB::Client.new(JikiConfig::GenerateAwsSettings.())
  end

  def self.ses_client
    require 'aws-sdk-sesv2'
    Aws::SESV2::Client.new(JikiConfig::GenerateAwsSettings.())
  end
end
