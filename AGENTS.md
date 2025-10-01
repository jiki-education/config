# Jiki Config Gem - Documentation for Agents

This gem provides centralized configuration and secrets management for the Jiki platform, following the same architectural patterns as exercism-config.

## Overview

The jiki-config gem manages configuration and secrets for Jiki's Rails API and related services. It uses AWS services in production and local YAML files for development/testing.

## Architecture

### Production (AWS-based)
- **Configuration**: Stored in DynamoDB table named `config`
  - Each row has an `id` (config key name) and `value` (config value)
  - Accessed via `Jiki.config.*`

- **Secrets**: Stored in AWS Secrets Manager as a JSON blob
  - Secret ID: `config`
  - Contains all sensitive credentials
  - Accessed via `Jiki.secrets.*`

### Development/Test (File-based)
- **Configuration**: `settings/local.yml` or `settings/ci.yml`
- **Secrets**: `settings/secrets.yml`
- **Personal overrides**: `~/.config/jiki/secrets.yml` (if exists, merges with settings/secrets.yml)

## Available Configuration Keys

### Database (Aurora PostgreSQL)
```ruby
Jiki.config.aurora_endpoint      # RDS cluster endpoint
Jiki.config.aurora_port          # Database port (usually 5432)
Jiki.config.aurora_database_name # Database name
```

### Secrets (Credentials)
```ruby
# Aurora Database
Jiki.secrets.aurora_username
Jiki.secrets.aurora_password

# SES Email (AWS Simple Email Service)
Jiki.secrets.ses_smtp_username
Jiki.secrets.ses_smtp_password
Jiki.secrets.ses_smtp_address
Jiki.secrets.ses_smtp_port
```

## Helper Methods

### AWS Client Helpers
```ruby
Jiki.dynamodb_client  # AWS DynamoDB client (for accessing config table)
Jiki.ses_client       # AWS SES client (for email operations)
```

These helper methods automatically configure the AWS clients with the correct region and credentials based on the current environment.

## Environment Detection

The gem detects the environment from these sources (in order):
1. `ENV['JIKI_ENV']`
2. `ENV['RAILS_ENV']`
3. `ENV['APP_ENV']`
4. `Rails.env` (if Rails is loaded)

Allowed environments: `development`, `test`, `production`

## Local Development Setup

### Prerequisites
- Docker (for localstack to simulate AWS services)
- Redis (for testing)

### Start LocalStack
```bash
docker run -dp 3042:8080 -p 3040:4566 -p 3041:4566 localstack/localstack
```

### Setup Configuration
```bash
cd jiki-config
bundle install
JIKI_ENV=development bundle exec setup_jiki_config
```

This will:
1. Create a local DynamoDB table named `config`
2. Load config values from `settings/local.yml` into DynamoDB
3. Create a Secrets Manager secret with values from `settings/secrets.yml`

### Using in Your Application

Add to your Gemfile:
```ruby
gem 'jiki-config', path: '../jiki-config'  # or from rubygems once published
```

In your code:
```ruby
require 'jiki-config'

# Access configuration
db_endpoint = Jiki.config.aurora_endpoint

# Access secrets
db_password = Jiki.secrets.aurora_password

# Use helper methods
dynamodb = Jiki.dynamodb_client
ses = Jiki.ses_client
```

## File Structure

```
jiki-config/
├── lib/
│   ├── jiki-config.rb              # Entry point with Zeitwerk loader
│   ├── jiki.rb                     # Main module with .config, .secrets, helpers
│   ├── jiki/
│   │   ├── config.rb               # OpenStruct wrapper for config
│   │   └── secrets.rb              # OpenStruct wrapper for secrets
│   └── jiki_config/
│       ├── version.rb              # Gem version
│       ├── environment.rb          # Environment object with helpers
│       ├── determine_environment.rb # Detects current environment
│       ├── generate_aws_settings.rb # Generates AWS client settings
│       ├── retrieve_config.rb      # Fetches config from DynamoDB or YAML
│       └── retrieve_secrets.rb     # Fetches secrets from Secrets Manager or YAML
├── settings/
│   ├── local.yml                   # Dev config values
│   ├── ci.yml                      # CI config values
│   └── secrets.yml                 # Dev secrets (not committed in real usage)
├── bin/
│   ├── setup_jiki_config           # Setup local DynamoDB and Secrets Manager
│   └── setup_jiki_local_aws        # Additional AWS setup utilities
└── test/                           # Test suite
```

## Testing

Run tests locally:
```bash
bundle exec rake test
```

Tests run with:
- LocalStack for AWS services
- Redis for caching tests
- Minitest framework

## Adding New Configuration Keys

1. **Add to settings files**: Update `settings/local.yml`, `settings/ci.yml`, `settings/secrets.yml`
2. **Document in AGENTS.md**: Add to "Available Configuration Keys" section
3. **Update tests**: Add tests for the new key in `test/`
4. **Run setup**: `bundle exec setup_jiki_config` to reload local DynamoDB

## Production Deployment

In production:
1. Terraform creates the DynamoDB `config` table
2. Terraform populates config values as items in the table
3. Terraform creates the Secrets Manager secret with sensitive credentials
4. ECS task IAM roles grant read access to the DynamoDB table and Secrets Manager secret
5. Application loads config on boot via `Jiki.config` and `Jiki.secrets`

## Important Notes

- **Never commit real secrets**: The `settings/secrets.yml` file should contain dummy values for local development
- **Use personal overrides**: For local development with real services, use `~/.config/jiki/secrets.yml`
- **AWS Region**: Currently hardcoded to `eu-west-2` in `GenerateAwsSettings`
- **LocalStack endpoint**: Defaults to `http://localhost:3040` for development

## Troubleshooting

### "No environment set" error
Set one of: `JIKI_ENV`, `RAILS_ENV`, or `APP_ENV`

### "Config could not be loaded" error
- Check LocalStack is running: `docker ps`
- Run setup: `bundle exec setup_jiki_config`

### Config values are nil
- Verify the key exists in settings YAML files
- Re-run setup to reload DynamoDB: `bundle exec setup_jiki_config --force`
