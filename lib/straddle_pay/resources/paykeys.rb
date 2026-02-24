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

      # Submit a review decision for a paykey.
      #
      # @param id [String] paykey ID
      # @param status [String] decision status (e.g. "approved", "rejected")
      # @return [Hash] updated paykey
      def review(id, status:, **options)
        payload = { status: status, **options }.compact
        headers = extract_headers(payload)
        @client.patch("v1/paykeys/#{id}/review", payload, headers: headers)
      end

      # Get the current review details for a paykey.
      #
      # @param id [String] paykey ID
      # @return [Hash] review details
      def get_review(id, **options)
        headers = extract_headers(options)
        @client.get("v1/paykeys/#{id}/review", headers: headers)
      end

      # Refresh a paykey's identity review decision.
      #
      # @param id [String] paykey ID
      # @param options [Hash] request body or header params
      # @return [Hash] refreshed paykey details
      def refresh_review(id, **options)
        payload = options.compact
        headers = extract_headers(payload)
        @client.put("v1/paykeys/#{id}/refresh_review", payload.empty? ? nil : payload, headers: headers)
      end

      # Refresh a paykey's balance.
      #
      # @param id [String] paykey ID
      # @param options [Hash] optional request body or header params
      # @return [Hash] refreshed paykey details
      def refresh_balance(id, **options)
        payload = options.compact
        headers = extract_headers(payload)
        @client.put("v1/paykeys/#{id}/refresh_balance", payload.empty? ? nil : payload, headers: headers)
      end

      # Unblock a paykey (R29 unblock flow).
      #
      # @param id [String] paykey ID
      # @param options [Hash] optional request body or header params
      # @return [Hash] unblocked paykey details
      def unblock(id, **options)
        payload = options.compact
        headers = extract_headers(payload)
        @client.patch("v1/paykeys/#{id}/unblock", payload.empty? ? nil : payload, headers: headers)
      end
    end
  end
end
