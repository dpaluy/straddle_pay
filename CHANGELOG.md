## [0.3.0] - 2026-02-20

### Changed
- Replace `base_url` with `environment: :sandbox/:production` as primary config
- `STRADDLE_ENVIRONMENT` env var replaces `STRADDLE_BASE_URL` for environment selection
- `base_url` remains as escape hatch for custom URLs
- `ENVIRONMENTS` hash replaces `SANDBOX_URL`/`PRODUCTION_URL` constants
- Client accepts `environment:` param for per-instance override

## [0.2.0] - 2026-02-20

### Added
- Webhook signature verification following Svix protocol

## [0.1.5] - 2026-02-20

### Fixed
- Aligned `charges.create` with required request fields and fixed `config` parameter coverage.
- Added missing endpoints from the official API spec:
  - Account settings accessor and endpoint: `GET /v1/account_settings/{account_id}`
  - Account capability requests: `POST /v1/accounts/{account_id}/capability_requests`, `GET /v1/accounts/{account_id}/capability_requests`
  - Funding events:
    - Corrected paths to `GET /v1/funding_events` and `GET /v1/funding_events/{id}`
    - Added `POST /v1/funding_events/simulate`
  - Bridge speedchex: `POST /v1/bridge/speedchex`
  - Charge and payout re-submission:
    - `POST /v1/charges/{id}/resubmit`
    - `POST /v1/payouts/{id}/resubmit`
  - Paykey lifecycle actions:
    - `GET /v1/paykeys/{id}/review`
    - `PUT /v1/paykeys/{id}/refresh_review`
    - `PUT /v1/paykeys/{id}/refresh_balance`
    - `PATCH /v1/paykeys/{id}/unblock`
  - Funding event payments:
    - `GET /v1/funding_event_payments/{id}`
- Fixed linked bank account create signature to match API optional `description`.

### Added
- New client accessors and resource classes for:
  - `client.account_settings`
  - `client.funding_event_payments`
  - `client.embed.accounts.capability_requests`

## [0.1.0] - 2026-02-19

### Added
- Initial release
- Full Straddle API v1 coverage (59 endpoints)
- Faraday-based HTTP client with configurable timeouts
- Global config with per-instance overrides
- Error hierarchy with validation detail accessors
- Auto-unwrapped response envelope
- Rails Engine support
