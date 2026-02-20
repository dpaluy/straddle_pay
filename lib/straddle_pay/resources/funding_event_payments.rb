# frozen_string_literal: true

module StraddlePay
  module Resources
    # Query funding event payment records.
    class FundingEventPayments < Base
      # List payments for a funding event.
      #
      # @param id [String] funding event ID
      # @param options [Hash] filter/pagination params or header params
      # @return [Hash] funding event payment list
      def get(id, **options)
        query = options.dup
        headers = extract_headers(query)
        @client.get("v1/funding_event_payments/#{id}", params: query, headers: headers)
      end
    end
  end
end
