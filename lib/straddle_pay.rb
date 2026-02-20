# frozen_string_literal: true

require_relative "straddle_pay/version"

# Ruby client for the Straddle payment infrastructure API.
#
# @example Global configuration
#   StraddlePay.configure do |config|
#     config.api_key  = ENV.fetch("STRADDLE_API_KEY")
#     config.base_url = StraddlePay::Config::PRODUCTION_URL
#   end
#
# @example Per-instance client
#   client = StraddlePay::Client.new(api_key: "sk_test_...")
#
# @see https://straddle.dev/api-reference Straddle API Reference
module StraddlePay
  autoload :Config, "straddle_pay/config"
  autoload :Client, "straddle_pay/client"
  autoload :Error, "straddle_pay/errors"
  autoload :AuthenticationError, "straddle_pay/errors"
  autoload :ClientError, "straddle_pay/errors"
  autoload :RateLimitError, "straddle_pay/errors"
  autoload :ServerError, "straddle_pay/errors"
  autoload :NetworkError, "straddle_pay/errors"
  autoload :SignatureVerificationError, "straddle_pay/errors"
  autoload :Webhook, "straddle_pay/webhook"

  module Resources
    autoload :AccountSettings, "straddle_pay/resources/account_settings"
    autoload :AccountCapabilityRequests, "straddle_pay/resources/account_capability_requests"
    autoload :Base, "straddle_pay/resources/base"
    autoload :Charges, "straddle_pay/resources/charges"
    autoload :Payouts, "straddle_pay/resources/payouts"
    autoload :Customers, "straddle_pay/resources/customers"
    autoload :CustomerReviews, "straddle_pay/resources/customer_reviews"
    autoload :Bridge, "straddle_pay/resources/bridge"
    autoload :BridgeLinks, "straddle_pay/resources/bridge_links"
    autoload :Paykeys, "straddle_pay/resources/paykeys"
    autoload :Payments, "straddle_pay/resources/payments"
    autoload :FundingEvents, "straddle_pay/resources/funding_events"
    autoload :FundingEventPayments, "straddle_pay/resources/funding_event_payments"
    autoload :Reports, "straddle_pay/resources/reports"
    autoload :Embed, "straddle_pay/resources/embed"
    autoload :EmbedAccounts, "straddle_pay/resources/embed_accounts"
    autoload :EmbedOrganizations, "straddle_pay/resources/embed_organizations"
    autoload :EmbedRepresentatives, "straddle_pay/resources/embed_representatives"
    autoload :EmbedLinkedBankAccounts, "straddle_pay/resources/embed_linked_bank_accounts"
  end

  class << self
    # @return [Config] current configuration instance
    def config
      @config ||= Config.new
    end

    # Yields the global configuration for modification.
    #
    # @yieldparam config [Config] the configuration instance
    def configure
      yield(config)
    end

    # Reset configuration to defaults.
    # @return [void]
    def reset_configuration!
      @config = nil
    end
  end
end

require_relative "straddle_pay/engine"
