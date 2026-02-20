# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage embedded accounts for platform/marketplace use.
    # Accessed via {Embed#accounts}.
    class EmbedAccounts < Base
      # Create an embedded account.
      #
      # @param organization_id [String] parent organization ID
      # @param account_type [String] account type (e.g. "standard")
      # @param business_profile [Hash] business details (must include :name)
      # @param access_level [String] access level (e.g. "standard")
      # @return [Hash] created account
      def create(organization_id:, account_type:, business_profile:, access_level:, **options)
        payload = {
          organization_id: organization_id, account_type: account_type,
          business_profile: business_profile, access_level: access_level, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/accounts", payload, headers: headers)
      end

      # Retrieve an account by ID.
      #
      # @param id [String] account ID
      # @return [Hash] account details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/accounts/#{id}", headers: headers)
      end

      # List accounts with optional filters.
      #
      # @return [Hash] paginated account list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/accounts", params: options, headers: headers)
      end

      # Update an account.
      #
      # @param id [String] account ID
      # @return [Hash] updated account
      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/accounts/#{id}", options, headers: headers)
      end

      # Onboard an account (accept terms of service).
      #
      # @param id [String] account ID
      # @param terms_of_service [Hash] ToS acceptance (must include accepted: true)
      # @return [Hash] onboarded account
      def onboard(id, terms_of_service:, **options)
        payload = { terms_of_service: terms_of_service, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/accounts/#{id}/onboard", payload, headers: headers)
      end

      # Simulate account status change (sandbox only).
      #
      # @param id [String] account ID
      # @param final_status [String] target status to simulate
      # @return [Hash] simulated account
      def simulate(id, final_status:, **options)
        payload = { final_status: final_status, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/accounts/#{id}/simulate", payload, headers: headers)
      end
    end
  end
end
