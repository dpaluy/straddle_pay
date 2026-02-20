# frozen_string_literal: true

module StraddlePay
  module Resources
    # Query funding events (bank settlement records).
    class FundingEvents < Base
      # List funding events with optional filters.
      #
      # @param options [Hash] filter/pagination params
      # @return [Hash] paginated funding event list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/funding-events", params: options, headers: headers)
      end

      # Retrieve a funding event by ID.
      #
      # @param id [String] funding event ID
      # @return [Hash] funding event details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/funding-events/#{id}", headers: headers)
      end
    end
  end
end
