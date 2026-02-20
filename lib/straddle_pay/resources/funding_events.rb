# frozen_string_literal: true

module StraddlePay
  module Resources
    class FundingEvents < Base
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/funding-events", params: options, headers: headers)
      end

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/funding-events/#{id}", headers: headers)
      end
    end
  end
end
