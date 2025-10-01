require "test_helper"

class JikiConfigTest < Minitest::Test
  def test_env_defined
    assert Jiki.env
  end

  def test_dynamodb_client_returns_client
    client = Jiki.dynamodb_client
    assert_instance_of Aws::DynamoDB::Client, client
  end

  def test_ses_client
    ses_client = Jiki.ses_client
    assert_equal "eu-west-2", ses_client.config.region
  end
end
