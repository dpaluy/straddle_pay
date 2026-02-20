# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage customer identity reviews.
    # Accessed via {Customers#reviews}.
    class CustomerReviews < Base
      # Get the identity review for a customer.
      #
      # @param customer_id [String] customer ID
      # @return [Hash] review details
      def get(customer_id, **options)
        headers = extract_headers(options)
        @client.get("v1/customers/#{customer_id}/review", headers: headers)
      end

      # Submit a review decision.
      #
      # @param customer_id [String] customer ID
      # @param status [String] decision status (e.g. "approved", "rejected")
      # @return [Hash] updated review
      def decision(customer_id, status:, **options)
        payload = { status: status, **options }.compact
        headers = extract_headers(payload)
        @client.patch("v1/customers/#{customer_id}/review", payload, headers: headers)
      end

      # Refresh a customer's identity review.
      #
      # @param customer_id [String] customer ID
      # @return [Hash] refreshed review
      def refresh(customer_id, **options)
        headers = extract_headers(options)
        @client.put("v1/customers/#{customer_id}/refresh_review", options, headers: headers)
      end
    end
  end
end
