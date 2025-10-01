module JikiConfig
  class RetrieveSecrets
    include Mandate

    def call
      return use_non_production_settings unless Jiki.env.production?

      retrieve_from_aws
    end

    private
    def use_non_production_settings
      require 'erb'
      require 'yaml'

      secrets_file = File.expand_path('../../settings/secrets.yml', __dir__)
      secrets = YAML.safe_load(ERB.new(File.read(secrets_file)).result)

      personal_secrets_file = "#{Dir.home}/.config/jiki/secrets.yml"
      if File.exist?(personal_secrets_file)
        personal_secrets = YAML.safe_load(ERB.new(File.read(personal_secrets_file)).result)
        Jiki::Secrets.new(secrets.merge(personal_secrets))
      else
        Jiki::Secrets.new(secrets)
      end
    end

    def retrieve_from_aws
      client = Aws::SecretsManager::Client.new(GenerateAwsSettings.())
      json = client.get_secret_value(secret_id: "config").secret_string
      Jiki::Secrets.new(JSON.parse(json))
    rescue StandardError => e
      raise Jiki::ConfigError, "Jiki's secrets could not be loaded: #{e.message}"
    end
  end
end
