# frozen_string_literal: true

module StraddlePay
  module Resources
    # Link bank accounts via direct details, Plaid, Quiltt, or TAN.
    # Accessed via {Bridge#links}.
    class BridgeLinks < Base
      # Link a bank account directly.
      #
      # @param customer_id [String] customer ID
      # @param account_number [String] bank account number
      # @param routing_number [String] bank routing number
      # @param account_type [String] "checking" or "savings"
      # @return [Hash] linked bank account
      def bank_account(customer_id:, account_number:, routing_number:, account_type:, **options)
        payload = {
          customer_id: customer_id, account_number: account_number,
          routing_number: routing_number, account_type: account_type, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/bank_account", payload, headers: headers)
      end

      # Link a bank account via Plaid.
      #
      # @param customer_id [String] customer ID
      # @param plaid_token [String] Plaid processor token
      # @return [Hash] linked bank account
      def plaid(customer_id:, plaid_token:, **options)
        payload = { customer_id: customer_id, plaid_token: plaid_token, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/plaid", payload, headers: headers)
      end

      # Link a bank account via Quiltt.
      #
      # @param customer_id [String] customer ID
      # @param quiltt_token [String] Quiltt session token
      # @return [Hash] linked bank account
      def quiltt(customer_id:, quiltt_token:, **options)
        payload = { customer_id: customer_id, quiltt_token: quiltt_token, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/quiltt", payload, headers: headers)
      end

      # Link a bank account via TAN (Tokenized Account Number).
      #
      # @param customer_id [String] customer ID
      # @param routing_number [String] bank routing number
      # @param account_type [String] "checking" or "savings"
      # @param tan [String] tokenized account number
      # @return [Hash] linked bank account
      def tan(customer_id:, routing_number:, account_type:, tan:, **options)
        payload = {
          customer_id: customer_id, routing_number: routing_number,
          account_type: account_type, tan: tan, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/tan", payload, headers: headers)
      end
    end
  end
end
