# StraddlePay

Ruby client for the [Straddle](https://straddle.dev) payment infrastructure API.

[![Gem Version](https://badge.fury.io/rb/straddle_pay.svg)](https://badge.fury.io/rb/straddle_pay)
[![ci](https://github.com/dpaluy/straddle_pay/actions/workflows/ci.yml/badge.svg)](https://github.com/dpaluy/straddle_pay/actions/workflows/ci.yml)

Lightweight, idiomatic Ruby wrapper using Faraday. No auto-generated code, no type system overhead — just clean Hash responses.

## Installation

```
bundle add straddle_pay
```

## Usage

Configure once:

```ruby
StraddlePay.configure do |config|
  config.api_key  = ENV.fetch("STRADDLE_API_KEY")
  config.base_url = StraddlePay::Config::PRODUCTION_URL  # default: sandbox
end
```

Per-instance overrides:

```ruby
client = StraddlePay::Client.new(
  api_key: "sk_different_key",
  base_url: "https://production.straddle.io"
)
```

### Environments

| Environment | URL |
|-------------|-----|
| Sandbox (default) | `https://sandbox.straddle.io` |
| Production | `https://production.straddle.io` |

### Rails

Create `config/initializers/straddle_pay.rb`:

```ruby
StraddlePay.configure do |config|
  config.api_key  = Rails.application.credentials.straddle_api_key
  config.base_url = StraddlePay::Config::PRODUCTION_URL
  config.logger   = Rails.logger
end
```

### Charges

```ruby
client = StraddlePay::Client.new

charge = client.charges.create(
  paykey: "pk_abc123",
  amount: 10_000,
  currency: "usd",
  description: "Monthly subscription",
  payment_date: "2026-03-01",
  consent_type: "internet",
  device: { ip_address: "192.168.1.1" },
  external_id: "order_456"
)
charge["id"] # => "ch_..."

client.charges.get("ch_abc123")
client.charges.update("ch_abc123", amount: 15_000)
client.charges.cancel("ch_abc123")
client.charges.hold("ch_abc123")
client.charges.release("ch_abc123")
client.charges.unmask("ch_abc123")
```

### Payouts

```ruby
payout = client.payouts.create(
  paykey: "pk_abc123",
  amount: 5_000,
  currency: "usd",
  description: "Vendor payment",
  payment_date: "2026-03-01",
  device: { ip_address: "192.168.1.1" },
  external_id: "payout_789"
)

# Cancel/hold/release require a reason
client.payouts.cancel("po_abc123", reason: "Duplicate payment")
client.payouts.hold("po_abc123", reason: "Under review")
client.payouts.release("po_abc123", reason: "Review complete")
```

### Customers

```ruby
customer = client.customers.create(
  name: "John Doe",
  type: "individual",
  email: "john@example.com",
  phone: "+15551234567",
  device: { ip_address: "192.168.1.1" }
)

customers = client.customers.list(page_number: 1, page_size: 25)

# Identity review
review = client.customers.reviews.get("cust_abc123")
client.customers.reviews.decision("cust_abc123", status: "approved")
client.customers.reviews.refresh("cust_abc123")
```

### Bridge (Bank Account Linking)

```ruby
session = client.bridge.initialize_session(customer_id: "cust_abc123")

# Direct bank account link
client.bridge.links.bank_account(
  customer_id: "cust_abc123",
  account_number: "1234567890",
  routing_number: "021000021",
  account_type: "checking"
)

# Or via Plaid/Quiltt
client.bridge.links.plaid(customer_id: "cust_abc123", plaid_token: "plaid_token")
client.bridge.links.quiltt(customer_id: "cust_abc123", quiltt_token: "quiltt_token")
```

### Paykeys

```ruby
client.paykeys.get("pk_abc123")
client.paykeys.list
client.paykeys.reveal("pk_abc123")
client.paykeys.cancel("pk_abc123")
```

### Embedded Accounts

```ruby
org = client.embed.organizations.create(name: "Partner Corp")

account = client.embed.accounts.create(
  organization_id: org["id"],
  account_type: "standard",
  business_profile: { name: "Partner Corp" },
  access_level: "standard"
)
client.embed.accounts.onboard(account["id"], terms_of_service: { accepted: true })

client.embed.representatives.create(
  account_id: account["id"],
  first_name: "Jane", last_name: "Smith",
  email: "jane@partner.com", dob: "1985-06-15",
  mobile_number: "+15559876543", relationship: "owner", ssn_last4: "4321"
)

client.embed.linked_bank_accounts.create(
  account_id: account["id"],
  bank_account: { account_number: "9876543210", routing_number: "021000021" },
  description: "Operating account"
)
```

### Scoped Requests

Pass `straddle_account_id` to scope requests to an embedded account:

```ruby
client.charges.create(
  paykey: "pk_abc",
  amount: 10_000,
  currency: "usd",
  description: "Scoped charge",
  payment_date: "2026-03-01",
  consent_type: "internet",
  device: { ip_address: "1.2.3.4" },
  external_id: "ext_1",
  straddle_account_id: "acct_partner123"
)
```

Headers `request_id`, `correlation_id`, and `idempotency_key` are also supported on all methods.

## Error Handling

```ruby
begin
  client.charges.create(...)
rescue StraddlePay::AuthenticationError => e
  # 401 or 403
rescue StraddlePay::ClientError => e
  # 400, 404, 409, 422
  e.error_type    # => "validation_error"
  e.error_items   # => [{"reference" => "email", "detail" => "is invalid"}]
rescue StraddlePay::RateLimitError
  # 429 - retry with backoff
rescue StraddlePay::ServerError
  # 500+
rescue StraddlePay::NetworkError
  # Timeout or connection failure
end
```

### API Reference

Full endpoint details: [straddle.dev/api-reference](https://straddle.dev/api-reference)

## Development

```
bundle exec rake test
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dpaluy/straddle_pay.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
