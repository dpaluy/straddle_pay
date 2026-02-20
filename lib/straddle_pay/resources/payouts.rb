# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage ACH payout (credit) transactions.
    #
    # @see https://straddle.dev/api-reference Straddle API Reference
    class Payouts < Base
      # Create a new payout.
      #
      # @param paykey [String] paykey identifier
      # @param amount [Integer] amount in cents
      # @param currency [String] three-letter currency code
      # @param description [String] payout description
      # @param payment_date [String] date in YYYY-MM-DD format
      # @param device [Hash] device info (must include :ip_address)
      # @param external_id [String] your external reference ID
      # @return [Hash] created payout
      def create(paykey:, amount:, currency:, description:, payment_date:, device:, external_id:, **options)
        payload = {
          paykey: paykey, amount: amount, currency: currency, description: description,
          payment_date: payment_date, device: device, external_id: external_id, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/payouts", payload, headers: headers)
      end

      # Retrieve a payout by ID.
      #
      # @param id [String] payout ID
      # @return [Hash] payout details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/payouts/#{id}", headers: headers)
      end

      # Update a payout.
      #
      # @param id [String] payout ID
      # @return [Hash] updated payout
      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/payouts/#{id}", options, headers: headers)
      end

      # Cancel a payout.
      #
      # @param id [String] payout ID
      # @param reason [String] cancellation reason (required)
      # @return [Hash] cancelled payout
      def cancel(id, reason:, **options)
        payload = { reason: reason, **options }.compact
        headers = extract_headers(payload)
        @client.put("v1/payouts/#{id}/cancel", payload, headers: headers)
      end

      # Place a payout on hold.
      #
      # @param id [String] payout ID
      # @param reason [String] hold reason (required)
      # @return [Hash] held payout
      def hold(id, reason:, **options)
        payload = { reason: reason, **options }.compact
        headers = extract_headers(payload)
        @client.put("v1/payouts/#{id}/hold", payload, headers: headers)
      end

      # Release a held payout.
      #
      # @param id [String] payout ID
      # @param reason [String] release reason (required)
      # @return [Hash] released payout
      def release(id, reason:, **options)
        payload = { reason: reason, **options }.compact
        headers = extract_headers(payload)
        @client.put("v1/payouts/#{id}/release", payload, headers: headers)
      end

      # Retrieve unmasked payout details.
      #
      # @param id [String] payout ID
      # @return [Hash] unmasked payout details
      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/payouts/#{id}/unmask", headers: headers)
      end

      # Resubmit a failed or reversed payout.
      #
      # @param id [String] payout ID
      # @param options [Hash] optional request body or header params
      # @return [Hash] resubmitted payout
      def resubmit(id, **options)
        payload = options.compact
        headers = extract_headers(payload)
        @client.post("v1/payouts/#{id}/resubmit", payload.empty? ? nil : payload, headers: headers)
      end
    end
  end
end
