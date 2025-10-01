module JikiConfig
  class DetermineEnvironment
    include Mandate

    def call
      env = ENV['JIKI_ENV'] || ENV['RAILS_ENV'] || ENV['APP_ENV']
      env = Rails.env.to_s if !env && Object.const_defined?(:Rails) && Rails.respond_to?(:env)

      raise Jiki::ConfigError, 'No environment set - set one of JIKI_ENV, RAILS_ENV or APP_ENV' unless env

      Environment.new(env)
    end
  end
end
