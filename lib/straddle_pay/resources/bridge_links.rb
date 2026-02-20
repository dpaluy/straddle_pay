# frozen_string_literal: true

module StraddlePay
  module Resources
    class BridgeLinks < Base
      def bank_account(customer_id:, account_number:, routing_number:, account_type:, **options)
        payload = {
          customer_id: customer_id, account_number: account_number,
          routing_number: routing_number, account_type: account_type, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/bank_account", payload, headers: headers)
      end

      def plaid(customer_id:, plaid_token:, **options)
        payload = { customer_id: customer_id, plaid_token: plaid_token, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/plaid", payload, headers: headers)
      end

      def quiltt(customer_id:, quiltt_token:, **options)
        payload = { customer_id: customer_id, quiltt_token: quiltt_token, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/quiltt", payload, headers: headers)
      end

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
