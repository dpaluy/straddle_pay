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
    end
  end
end
