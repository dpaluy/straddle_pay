# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage capability requests for embedded accounts.
    # Accessed via {EmbedAccounts#capability_requests}.
    class AccountCapabilityRequests < Base
      # Request a capability for an account.
      #
      # @param account_id [String] account ID
      # @param options [Hash] request body or header params
      # @return [Hash] created capability request
      def create(account_id, **options)
        payload = options.compact
        headers = extract_headers(payload)
        @client.post("v1/accounts/#{account_id}/capability_requests", payload.empty? ? nil : payload, headers: headers)
      end

      # List capability requests for an account.
      #
      # @param account_id [String] account ID
      # @param options [Hash] filter params or header params
      # @return [Hash] paginated capability requests
      def list(account_id, **options)
        query = options.dup
        headers = extract_headers(query)
        @client.get("v1/accounts/#{account_id}/capability_requests", params: query, headers: headers)
      end
    end
  end
end
