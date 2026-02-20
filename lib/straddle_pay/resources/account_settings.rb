# frozen_string_literal: true

module StraddlePay
  module Resources
    # Retrieve account settings.
    class AccountSettings < Base
      # Get resolved settings for an account.
      #
      # @param account_id [String] account ID
      # @param options [Hash] header params
      # @return [Hash] resolved account settings
      def get(account_id, **options)
        headers = extract_headers(options)
        @client.get("v1/account_settings/#{account_id}", headers: headers)
      end
    end
  end
end
