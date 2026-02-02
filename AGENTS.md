# Instructions for Coding Agents

This file provides guidance to Agents (e.g. Claude Code) when working with code in this repository.

## Overview

The jiki-config gem provides centralized configuration and secrets management for the Jiki platform. It uses AWS services in production and local YAML files for development/testing.

## Public API

- `Jiki.env` - Environment object with `.development?`, `.test?`, `.production?` helpers
- `Jiki.config.*` - Configuration values (e.g., `Jiki.config.aurora_endpoint`)
- `Jiki.secrets.*` - Sensitive credentials (e.g., `Jiki.secrets.aurora_password`)
- AWS client helpers: `Jiki.dynamodb_client`, `Jiki.s3_client`, `Jiki.ses_client`, `Jiki.lambda_client`, `Jiki.r2_client`

All classes use the Mandate pattern - callable with `.()` syntax.

## Environment Detection

Detected from (in order): `JIKI_ENV` → `RAILS_ENV` → `APP_ENV` → `Rails.env`

Allowed values: `development`, `test`, `production`

## Storage

**Production:**
- Config: DynamoDB table `config` (key: `id`, value: `value`)
- Secrets: AWS Secrets Manager (secret ID: `config`, stored as JSON)

**Development/Test:**
- Config: `settings/local.yml` (or `settings/ci.yml` if `JIKI_CI` is set)
- Secrets: `settings/secrets.yml`, merged with `~/.config/jiki/secrets.yml` if it exists

YAML files support ERB interpolation for environment variables.

## Adding New Keys

1. Add to `settings/local.yml`, `settings/ci.yml`, and/or `settings/secrets.yml`
2. Run `bundle exec setup_jiki_config` to reload local DynamoDB/Secrets Manager
3. For production: update Terraform config in `../terraform`

## Testing

```bash
bundle exec rake test
```

Uses Minitest with Mocha. Tests run against production-like behavior (mocked AWS).
