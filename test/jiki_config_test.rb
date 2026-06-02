require "test_helper"

class JikiConfigTest < Minitest::Test
  def test_env_defined
    assert Jiki.env
  end

  def test_dynamodb_client_returns_client
    client = Jiki.dynamodb_client
    assert_instance_of Aws::DynamoDB::Client, client
  end

  def test_s3_client
    s3_client = Jiki.s3_client
    assert_equal "eu-west-1", s3_client.config.region
  end

  def test_ses_client
    ses_client = Jiki.ses_client
    assert_equal "eu-west-1", ses_client.config.region
  end

  def test_r2_client_disables_default_checksums
    Jiki.stubs(:secrets).returns(stub(r2_access_key_id: "key", r2_secret_access_key: "secret"))
    Jiki.stubs(:config).returns(stub(r2_account_id: "account-id"))

    r2_client = Jiki.r2_client
    assert_equal "when_required", r2_client.config.request_checksum_calculation
    assert_equal "when_required", r2_client.config.response_checksum_validation
  end
end
