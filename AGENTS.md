# StraddlePay Ruby Gem

Idiomatic Ruby gem wrapping the [Straddle API](https://straddle.dev/api-reference) for payment infrastructure. Alternative to the official auto-generated `straddle` gem.

## Architecture

- **Pattern**: API wrapper gem following `reducto_ai` conventions
- **HTTP**: Faraday ~> 2.9 with manual JSON encode/decode
- **Config**: Global singleton (`StraddlePay.configure`) + per-instance client overrides
- **Responses**: Raw Hashes, auto-unwrapped from Straddle `{meta, response_type, data}` envelope
- **Errors**: Hierarchy with `error_type` and `error_items` for Straddle validation details
- **Testing**: Minitest + WebMock, TDD workflow
- **Ruby**: >= 3.2.0

## Key Files

| File | Purpose |
|------|---------|
| `lib/straddle_pay.rb` | Entry point, module config, requires |
| `lib/straddle_pay/client.rb` | Faraday HTTP client, response handling |
| `lib/straddle_pay/config.rb` | Config class with ENV defaults |
| `lib/straddle_pay/errors.rb` | Error hierarchy (5 classes) |
| `lib/straddle_pay/resources/base.rb` | Shared header extraction |
| `lib/straddle_pay/resources/*.rb` | 14 resource classes |

## Conventions

- `frozen_string_literal: true` on every file
- Resources inherit from `Resources::Base`
- Header params (`straddle_account_id`, `request_id`, `correlation_id`, `idempotency_key`) extracted via `extract_headers` before requests
- Sub-resources accessed via delegation: `client.customers.reviews`, `client.bridge.links`, `client.embed.accounts`
- All resource methods accept `**options` splat for forward-compatibility
- Dev dependencies in Gemfile only, runtime deps in gemspec
- Tests use shared `TestConfig` mixin with `setup_config` / `teardown_config`

## API Structure

9 top-level resources + 5 sub-resources = 14 resource classes, 59 endpoints total.

### Core
- `Customers` (6 methods + `reviews` accessor)
- `CustomerReviews` (3 methods)
- `Charges` (7 methods)
- `Payouts` (7 methods)

### Bridge
- `Bridge` (1 method + `links` accessor)
- `BridgeLinks` (4 methods)

### Paykeys
- `Paykeys` (6 methods)

### Supporting
- `Payments` (1 method)
- `FundingEvents` (2 methods)
- `Reports` (1 method)

### Embed (via `client.embed.*`)
- `EmbedAccounts` (6 methods)
- `EmbedOrganizations` (3 methods)
- `EmbedRepresentatives` (5 methods)
- `EmbedLinkedBankAccounts` (6 methods)

## Do NOT

- Add Sorbet, RBI, or RBS type definitions
- Use `net/http` directly — always use Faraday
- Wrap responses in model objects — return raw Hashes
- Add rubocop-rails-omakase (transitive Rails deps)
- Skip `frozen_string_literal: true`
- Put dev dependencies in gemspec
