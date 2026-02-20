# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage linked bank accounts for embedded accounts.
    # Accessed via {Embed#linked_bank_accounts}.
    class EmbedLinkedBankAccounts < Base
      # Link a bank account to an embedded account.
      #
      # @param account_id [String] parent account ID
      # @param bank_account [Hash] bank details (account_number, routing_number)
      # @param description [String, nil] account description
      # @return [Hash] created linked bank account
      def create(account_id:, bank_account:, description: nil, **options)
        payload = {
          account_id: account_id, bank_account: bank_account,
          description: description, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/linked_bank_accounts", payload, headers: headers)
      end

      # Retrieve a linked bank account by ID.
      #
      # @param id [String] linked bank account ID
      # @return [Hash] linked bank account details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/linked_bank_accounts/#{id}", headers: headers)
      end

      # List linked bank accounts with optional filters.
      #
      # @return [Hash] paginated linked bank account list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/linked_bank_accounts", params: options, headers: headers)
      end

      # Update a linked bank account.
      #
      # @param id [String] linked bank account ID
      # @return [Hash] updated linked bank account
      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/linked_bank_accounts/#{id}", options, headers: headers)
      end

      # Cancel a linked bank account.
      #
      # @param id [String] linked bank account ID
      # @return [Hash] cancelled linked bank account
      def cancel(id, **options)
        headers = extract_headers(options)
        @client.patch("v1/linked_bank_accounts/#{id}/cancel", options.empty? ? nil : options, headers: headers)
      end

      # Retrieve unmasked linked bank account details.
      #
      # @param id [String] linked bank account ID
      # @return [Hash] unmasked linked bank account details
      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/linked_bank_accounts/#{id}/unmask", headers: headers)
      end
    end
  end
end
