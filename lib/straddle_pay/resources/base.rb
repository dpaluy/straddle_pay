# frozen_string_literal: true

module StraddlePay
  # Namespace for all API resource classes.
  module Resources
    # Base class for API resources. Provides header extraction for
    # Straddle-specific headers (account scoping, request tracking, idempotency).
    class Base
      # @api private
      HEADER_KEYS = {
        straddle_account_id: "Straddle-Account-Id",
        request_id: "Request-Id",
        correlation_id: "Correlation-Id",
        idempotency_key: "Idempotency-Key"
      }.freeze

      # @param client [Client] the HTTP client instance
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
