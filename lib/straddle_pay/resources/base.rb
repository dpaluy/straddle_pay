# frozen_string_literal: true

module StraddlePay
  module Resources
    class Base
      HEADER_KEYS = {
        straddle_account_id: "Straddle-Account-Id",
        request_id: "Request-Id",
        correlation_id: "Correlation-Id",
        idempotency_key: "Idempotency-Key"
      }.freeze

      def initialize(client)
        @client = client
      end

      private

      def extract_headers(params)
        headers = {}
        HEADER_KEYS.each do |key, header|
          headers[header] = params.delete(key).to_s if params.key?(key)
        end
        headers
      end
    end
  end
end
