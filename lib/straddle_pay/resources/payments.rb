# frozen_string_literal: true

module StraddlePay
  module Resources
    # Query unified payment records (charges and payouts).
    class Payments < Base
      # List payments with optional filters.
      #
      # @param options [Hash] filter/pagination params
      # @return [Hash] paginated payment list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/payments", params: options, headers: headers)
      end
    end
  end
end
