module JikiConfig
  class GenerateAwsSettings
    include Mandate

    def call
      {
        region: 'eu-west-2',
        endpoint:,
        access_key_id: aws_access_key_id,
        secret_access_key: aws_secret_access_key
      }.select { |_k, v| v }
    end

    memoize
    def aws_access_key_id
      Jiki.env.production? ? nil : 'FAKE'
    end

    memoize
    def aws_secret_access_key
      Jiki.env.production? ? nil : 'FAKE'
    end

    memoize
    def endpoint
      return nil if Jiki.env.production?
      return "http://127.0.0.1:#{ENV['AWS_PORT']}" if Jiki.env.test? && ENV['JIKI_CI']

      "http://localhost:3040"
    end
  end
end
