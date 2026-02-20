# frozen_string_literal: true

module StraddlePay
  module Resources
    class Bridge < Base
      def links = @links ||= BridgeLinks.new(@client)

      def initialize_session(customer_id:, **options)
        payload = { customer_id: customer_id, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/bridge/initialize", payload, headers: headers)
      end
    end
  end
end
