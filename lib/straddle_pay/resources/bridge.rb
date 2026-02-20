# frozen_string_literal: true

module StraddlePay
  module Resources
    # Bank account linking via Bridge.
    class Bridge < Base
      # @return [BridgeLinks] bank account link sub-resource
      def links = @links ||= BridgeLinks.new(@client)

      # Initialize a Bridge session for a customer.
      #
      # @param customer_id [String] customer ID
      # @return [Hash] session details
      def initialize_session(customer_id:, **options)
        payload = { customer_id: customer_id, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/initialize", payload, headers: headers)
      end

      # Create a paykey from a Speedchex token.
      #
      # @param customer_id [String] customer ID
      # @param speedchex_token [String] Speedchex token
      # @param options [Hash] additional fields or header params
      # @return [Hash] created paykey
      def speedchex(customer_id:, speedchex_token:, **options)
        payload = {
          customer_id: customer_id, speedchex_token: speedchex_token, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/speedchex", payload, headers: headers)
      end
    end
  end
end
