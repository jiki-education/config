module JikiConfig
  class RetrieveConfig
    include Mandate

    def call
      return use_non_production_settings unless Jiki.env.production?

      retrieve_from_dynamodb
    end

    private
    def use_non_production_settings
      require 'erb'
      require 'yaml'

      settings_file = File.expand_path("../../../settings/#{settings_filename}.yml", __FILE__)
      settings = YAML.safe_load(ERB.new(File.read(settings_file)).result)

      Jiki::Config.new(settings, {})
    end

    def retrieve_from_dynamodb
      resp = Jiki.dynamodb_client.scan({ table_name: 'config' })
      items = resp.to_h[:items]
      data = items.each_with_object({}) do |item, h|
        h[item['id']] = item['value']
      end

      aws_settings = GenerateAwsSettings.()
      Jiki::Config.new(data, aws_settings)
    rescue Jiki::ConfigError
      raise
    rescue StandardError => e
      raise Jiki::ConfigError, "Jiki Config could not be loaded: #{e.message}"
    end

    def settings_filename
      ENV["JIKI_CI"] ? 'ci' : 'local'
    end
  end
end
