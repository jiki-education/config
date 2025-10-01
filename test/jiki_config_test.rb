require "test_helper"

class JikiConfigTest < Minitest::Test
  def test_config_loaded_from_yaml
    ENV['JIKI_ENV'] = 'development'

    config = Jiki.config
    assert_equal 'localhost', config.aurora_endpoint
    assert_equal 5432, config.aurora_port
    assert_equal 'jiki_development', config.aurora_database_name
  end

  def test_secrets_loaded_from_yaml
    ENV['JIKI_ENV'] = 'development'

    secrets = Jiki.secrets
    assert_equal 'jiki_user', secrets.aurora_username
    assert_equal 'jiki_password', secrets.aurora_password
    assert_equal 'fake-ses-username', secrets.ses_smtp_username
  end

  def test_environment_detection
    ENV['JIKI_ENV'] = 'test'
    env = Jiki.env

    assert env.test?
    refute env.development?
    refute env.production?
  end

  def test_dynamodb_client_returns_client
    ENV['JIKI_ENV'] = 'development'

    client = Jiki.dynamodb_client
    assert_instance_of Aws::DynamoDB::Client, client
  end
end
