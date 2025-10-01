require_relative 'lib/jiki_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'jiki-config'
  spec.version       = JikiConfig::VERSION
  spec.authors       = ['Jeremy Walker']
  spec.email         = ['jez.walker@gmail.com']

  spec.summary       = 'Retrieves stored config for Jiki'
  spec.homepage      = 'https://jiki.io'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.2.1')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jiki-io/config'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = %w[
    setup_jiki_config
    setup_jiki_local_aws
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk-dynamodb', '~> 1.0'
  spec.add_dependency 'aws-sdk-secretsmanager', '~> 1.0'
  spec.add_dependency 'mandate'
  spec.add_dependency 'zeitwerk'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'rake', '~> 12.3'

  # Optional AWS service dependencies
  spec.add_development_dependency 'aws-sdk-sesv2'
end
