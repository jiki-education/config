module JikiConfig
  class Environment
    ALLOWED_ENVS = %(development test production).freeze
    private_constant :ALLOWED_ENVS

    def initialize(raw_env)
      @env = raw_env.to_s

      unless ALLOWED_ENVS.include?(env)
        raise Jiki::ConfigError, "environment must be one of development, test or production. Got #{env}."
      end
    end

    def ==(other)
      env == other.to_s
    end

    def eql?(other)
      env == other.to_s
    end

    def hash
      env.hash
    end

    def to_s
      env
    end

    def inspect
      env
    end

    def development?
      env == "development"
    end

    def test?
      env == "test"
    end

    def production?
      env == "production"
    end

    private
    attr_reader :env
  end
end
