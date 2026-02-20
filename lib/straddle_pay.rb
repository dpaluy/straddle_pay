# frozen_string_literal: true

require_relative "straddle_pay/version"

module StraddlePay
  autoload :Config, "straddle_pay/config"
  autoload :Client, "straddle_pay/client"
  autoload :Error, "straddle_pay/errors"
  autoload :AuthenticationError, "straddle_pay/errors"
  autoload :ClientError, "straddle_pay/errors"
  autoload :RateLimitError, "straddle_pay/errors"
  autoload :ServerError, "straddle_pay/errors"
  autoload :NetworkError, "straddle_pay/errors"

  module Resources
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
    autoload :Reports, "straddle_pay/resources/reports"
    autoload :Embed, "straddle_pay/resources/embed"
    autoload :EmbedAccounts, "straddle_pay/resources/embed_accounts"
    autoload :EmbedOrganizations, "straddle_pay/resources/embed_organizations"
    autoload :EmbedRepresentatives, "straddle_pay/resources/embed_representatives"
    autoload :EmbedLinkedBankAccounts, "straddle_pay/resources/embed_linked_bank_accounts"
  end

  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield(config)
    end

    def reset_configuration!
      @config = nil
    end
  end
end

require_relative "straddle_pay/engine"
