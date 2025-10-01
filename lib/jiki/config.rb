module Jiki
  class Config < OpenStruct
    def initialize(data, aws_settings)
      super(data)
      self.aws_settings = aws_settings
    end

    def method_missing(name, *args)
      super.tap do |val|
        next unless val.nil?

        keys = to_h.keys
        raise NoMethodError, name unless keys.include?(name.to_s) || keys.include?(name.to_sym)
      end
    end

    def respond_to_missing?(*args)
      super
    rescue NoMethodError
      false
    end

    def to_json(*_args)
      to_h.to_json
    end
  end
end
