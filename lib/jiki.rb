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

  def self.s3_client
    require 'aws-sdk-s3'
    Aws::S3::Client.new(
      JikiConfig::GenerateAwsSettings.().merge(
        force_path_style: true
      )
    )
  end

  def self.ses_client
    require 'aws-sdk-sesv2'
    Aws::SESV2::Client.new(JikiConfig::GenerateAwsSettings.())
  end

  def self.lambda_client
    require 'aws-sdk-lambda'
    Aws::Lambda::Client.new(JikiConfig::GenerateAwsSettings.())
  end

  def self.r2_client
    require 'aws-sdk-s3'
    Aws::S3::Client.new(
      access_key_id: secrets.r2_access_key_id,
      secret_access_key: secrets.r2_secret_access_key,
      endpoint: "https://#{config.r2_account_id}.r2.cloudflarestorage.com",
      region: 'auto',
      force_path_style: true
    )
  end
end
