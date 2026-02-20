---
name: straddle
description: |
  Guide for using the straddle_pay Ruby gem to interact with the Straddle payment API.
  Use when implementing payment flows, bank account linking, customer management,
  or embedded account operations with Straddle.
---

# StraddlePay Gem Usage

Ruby client for the [Straddle API](https://straddle.dev/api-reference). Lightweight Faraday wrapper returning raw Hash responses.

## Setup

### Standalone

```ruby
StraddlePay.configure do |config|
  config.api_key  = ENV.fetch("STRADDLE_API_KEY")
  config.base_url = StraddlePay::Config::PRODUCTION_URL  # default: sandbox
end

client = StraddlePay::Client.new
```

### Rails

```ruby
# config/initializers/straddle_pay.rb
StraddlePay.configure do |config|
  config.api_key  = Rails.application.credentials.straddle_api_key
  config.base_url = StraddlePay::Config::PRODUCTION_URL
  config.logger   = Rails.logger
end
```

### Per-Instance Override

```ruby
client = StraddlePay::Client.new(
  api_key: "sk_different_key",
  base_url: "https://production.straddle.com",
  open_timeout: 10,
  read_timeout: 60
)
```

## Config

| Attribute | ENV var | Default |
|-----------|---------|---------|
| `api_key` | `STRADDLE_API_KEY` | nil (required) |
| `base_url` | `STRADDLE_BASE_URL` | `https://sandbox.straddle.com` |
| `open_timeout` | `STRADDLE_OPEN_TIMEOUT` | 5 |
| `read_timeout` | `STRADDLE_READ_TIMEOUT` | 30 |
| `logger` | - | Rails.logger or $stderr |

Constants: `StraddlePay::Config::SANDBOX_URL`, `StraddlePay::Config::PRODUCTION_URL`

## Resources

All methods return raw `Hash` responses (auto-unwrapped from Straddle's `{meta, response_type, data}` envelope).

All methods accept optional header kwargs: `straddle_account_id:`, `request_id:`, `correlation_id:`, `idempotency_key:`.

### Charges

```ruby
client.charges.create(
  paykey:, amount:, currency:, description:,
  payment_date:, consent_type:, device:, external_id:
)
client.charges.get(id)
client.charges.update(id, **attrs)
client.charges.cancel(id)
client.charges.hold(id)
client.charges.release(id)
client.charges.unmask(id)
```

### Payouts

```ruby
client.payouts.create(
  paykey:, amount:, currency:, description:,
  payment_date:, device:, external_id:
)
client.payouts.get(id)
client.payouts.update(id, **attrs)
client.payouts.cancel(id, reason:)    # reason required
client.payouts.hold(id, reason:)      # reason required
client.payouts.release(id, reason:)   # reason required
client.payouts.unmask(id)
```

### Customers

```ruby
client.customers.create(name:, type:, email:, phone:, device:)
client.customers.get(id)
client.customers.list(page_number: 1, page_size: 25)
client.customers.update(id, **attrs)
client.customers.delete(id)
client.customers.unmasked(id)
```

### Customer Reviews (sub-resource)

```ruby
client.customers.reviews.get(customer_id)
client.customers.reviews.decision(customer_id, status:)
client.customers.reviews.refresh(customer_id)
```

### Bridge (Bank Account Linking)

```ruby
client.bridge.initialize_session(customer_id:)
```

### Bridge Links (sub-resource)

```ruby
client.bridge.links.bank_account(
  customer_id:, account_number:, routing_number:, account_type:
)
client.bridge.links.plaid(customer_id:, plaid_token:)
client.bridge.links.quiltt(customer_id:, quiltt_token:)
client.bridge.links.tan(customer_id:, routing_number:, account_type:, tan:)
```

### Paykeys

```ruby
client.paykeys.get(id)
client.paykeys.list
client.paykeys.unmasked(id)
client.paykeys.reveal(id)
client.paykeys.cancel(id)
client.paykeys.review(id, **attrs)
```

### Payments

```ruby
client.payments.list(**filters)
```

### Funding Events

```ruby
client.funding_events.list(**filters)
client.funding_events.get(id)
```

### Reports

```ruby
client.reports.total_customers_by_status(**filters)
```

### Embedded Accounts

```ruby
# Organizations
client.embed.organizations.create(name:)
client.embed.organizations.get(id)
client.embed.organizations.list

# Accounts
client.embed.accounts.create(
  organization_id:, account_type:, business_profile:, access_level:
)
client.embed.accounts.get(id)
client.embed.accounts.list
client.embed.accounts.update(id, **attrs)
client.embed.accounts.onboard(id, terms_of_service:)
client.embed.accounts.simulate(id, final_status:)  # sandbox only

# Representatives
client.embed.representatives.create(
  account_id:, first_name:, last_name:, email:,
  dob:, mobile_number:, relationship:, ssn_last4:
)
client.embed.representatives.get(id)
client.embed.representatives.list
client.embed.representatives.update(id, **attrs)
client.embed.representatives.unmask(id)

# Linked Bank Accounts
client.embed.linked_bank_accounts.create(
  account_id:, bank_account:, description:
)
client.embed.linked_bank_accounts.get(id)
client.embed.linked_bank_accounts.list
client.embed.linked_bank_accounts.update(id, **attrs)
client.embed.linked_bank_accounts.cancel(id)
client.embed.linked_bank_accounts.unmask(id)
```

## Scoped Requests

Pass `straddle_account_id:` to scope any request to an embedded account:

```ruby
client.charges.create(
  paykey: "pk_abc", amount: 10_000, currency: "usd",
  description: "Scoped charge", payment_date: "2026-03-01",
  consent_type: "internet", device: { ip_address: "1.2.3.4" },
  external_id: "ext_1", straddle_account_id: "acct_partner123"
)
```

## Error Handling

```ruby
begin
  client.charges.create(...)
rescue StraddlePay::AuthenticationError => e
  # 401, 403
rescue StraddlePay::ClientError => e
  # 400, 404, 409, 422
  e.status       # => 422
  e.error_type   # => "validation_error"
  e.error_items  # => [{"reference" => "email", "detail" => "is invalid"}]
  e.body         # => full response hash
rescue StraddlePay::RateLimitError
  # 429 - retry with backoff
rescue StraddlePay::ServerError
  # 500+
rescue StraddlePay::NetworkError
  # Timeout or connection failure
end
```

Error hierarchy: `Error` < `StandardError` with subclasses `AuthenticationError`, `ClientError`, `RateLimitError`, `ServerError`, `NetworkError`.

## Architecture Notes

- All resources inherit from `StraddlePay::Resources::Base`
- Header params (`straddle_account_id`, `request_id`, `correlation_id`, `idempotency_key`) are extracted from kwargs into HTTP headers via `extract_headers`
- Sub-resources accessed via delegation: `client.customers.reviews`, `client.bridge.links`, `client.embed.accounts`
- All resource methods accept `**options` for forward-compatibility with new API fields
- Responses are auto-unwrapped: Straddle returns `{data: ...}` and the gem returns just the `data` value
- JSON encoding/decoding is manual (no middleware) via `JSON.generate` / `JSON.parse`
