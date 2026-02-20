# frozen_string_literal: true

module StraddlePay
  module Resources
    class CustomerReviews < Base
      def get(customer_id, **options)
        headers = extract_headers(options)
        @client.get("v1/customers/#{customer_id}/review", headers: headers)
      end

      def decision(customer_id, status:, **options)
        payload = { status: status, **options }.compact
        headers = extract_headers(payload)
        @client.patch("v1/customers/#{customer_id}/review", payload, headers: headers)
      end

      def refresh(customer_id, **options)
        headers = extract_headers(options)
        @client.put("v1/customers/#{customer_id}/refresh_review", options, headers: headers)
      end
    end
  end
end
