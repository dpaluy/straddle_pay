# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage paykeys (tokenized bank account references).
    class Paykeys < Base
      # Retrieve a paykey by ID.
      #
      # @param id [String] paykey ID
      # @return [Hash] paykey details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/paykeys/#{id}", headers: headers)
      end

      # List paykeys with optional filters.
      #
      # @return [Hash] paginated paykey list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/paykeys", params: options, headers: headers)
      end

      # Retrieve unmasked paykey details.
      #
      # @param id [String] paykey ID
      # @return [Hash] unmasked paykey details
      def unmasked(id, **options)
        headers = extract_headers(options)
        @client.get("v1/paykeys/#{id}/unmasked", headers: headers)
      end

      # Reveal full paykey details (sensitive).
      #
      # @param id [String] paykey ID
      # @return [Hash] revealed paykey
      def reveal(id, **options)
        headers = extract_headers(options)
        @client.get("v1/paykeys/#{id}/reveal", headers: headers)
      end

      # Cancel a paykey.
      #
      # @param id [String] paykey ID
      # @return [Hash] cancelled paykey
      def cancel(id, **options)
        headers = extract_headers(options)
        @client.put("v1/paykeys/#{id}/cancel", options, headers: headers)
      end

      # Submit a paykey for review.
      #
      # @param id [String] paykey ID
      # @return [Hash] review result
      def review(id, **options)
        headers = extract_headers(options)
        @client.patch("v1/paykeys/#{id}/review", options, headers: headers)
      end
    end
  end
end
