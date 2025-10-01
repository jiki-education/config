# Jiki Config

Configuration and secrets management gem for the Jiki platform.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jiki-config'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jiki-config

## Usage

```ruby
require 'jiki-config'

# Access configuration
Jiki.config.aurora_endpoint
Jiki.config.aurora_port
Jiki.config.aurora_database_name

# Access secrets
Jiki.secrets.aurora_username
Jiki.secrets.aurora_password
Jiki.secrets.ses_smtp_username
Jiki.secrets.ses_smtp_password

# Get AWS clients
Jiki.dynamodb_client
Jiki.ses_client

# Check environment
Jiki.env.development?
Jiki.env.test?
Jiki.env.production?
```

## Local Development

### Prerequisites

- Docker (for LocalStack)
- Ruby 3.2.1+

### Setup

1. Start LocalStack:
```bash
docker run -dp 3042:8080 -p 3040:4566 -p 3041:4566 localstack/localstack
```

2. Install dependencies:
```bash
bundle install
```

3. Setup local AWS services:
```bash
JIKI_ENV=development bundle exec setup_jiki_config
```

This will create a local DynamoDB table and Secrets Manager secret with values from the `settings/` directory.

## Configuration

The gem uses different configuration sources based on the environment:

- **Production**: AWS DynamoDB (table: `config`) and AWS Secrets Manager (secret: `config`)
- **Development/Test**: YAML files in `settings/` directory

### Environment Detection

The environment is determined from (in order):
1. `ENV['JIKI_ENV']`
2. `ENV['RAILS_ENV']`
3. `ENV['APP_ENV']`
4. `Rails.env` (if Rails is loaded)

### Available Configuration Keys

#### Database (Aurora PostgreSQL)
- `aurora_endpoint` - RDS cluster endpoint
- `aurora_port` - Database port
- `aurora_database_name` - Database name

#### Secrets
- `aurora_username` - Database username
- `aurora_password` - Database password
- `ses_smtp_username` - SES SMTP username
- `ses_smtp_password` - SES SMTP password
- `ses_smtp_address` - SES SMTP server
- `ses_smtp_port` - SES SMTP port

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jiki-io/config.

## License

See LICENSE file for details.

---

Copyright (c) 2025 Jiki Ltd. All rights reserved.
