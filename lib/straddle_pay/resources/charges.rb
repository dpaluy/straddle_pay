# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage ACH charge (debit) transactions.
    #
    # @see https://straddle.dev/api-reference Straddle API Reference
    class Charges < Base
      # Create a new charge.
      #
      # @param paykey [String] paykey identifier
      # @param amount [Integer] amount in cents
      # @param currency [String] three-letter currency code (e.g. "usd")
      # @param description [String] charge description
      # @param payment_date [String] date in YYYY-MM-DD format
      # @param consent_type [String] consent type (e.g. "internet")
      # @param device [Hash] device info (must include :ip_address)
      # @param external_id [String] your external reference ID
      # @param options [Hash] additional fields or header params
      # @return [Hash] created charge
      def create(paykey:, amount:, currency:, description:, payment_date:, consent_type:, device:, external_id:,
                 **options)
        payload = {
          paykey: paykey, amount: amount, currency: currency, description: description,
          payment_date: payment_date, consent_type: consent_type, device: device,
          external_id: external_id, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/charges", payload, headers: headers)
      end

      # Retrieve a charge by ID.
      #
      # @param id [String] charge ID
      # @return [Hash] charge details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/charges/#{id}", headers: headers)
      end

      # Update a charge.
      #
      # @param id [String] charge ID
      # @return [Hash] updated charge
      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}", options, headers: headers)
      end

      # Cancel a charge.
      #
      # @param id [String] charge ID
      # @return [Hash] cancelled charge
      def cancel(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}/cancel", options, headers: headers)
      end

      # Place a charge on hold.
      #
      # @param id [String] charge ID
      # @return [Hash] held charge
      def hold(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}/hold", options, headers: headers)
      end

      # Release a held charge.
      #
      # @param id [String] charge ID
      # @return [Hash] released charge
      def release(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}/release", options, headers: headers)
      end

      # Retrieve unmasked charge details.
      #
      # @param id [String] charge ID
      # @return [Hash] unmasked charge details
      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/charges/#{id}/unmask", headers: headers)
      end
    end
  end
end
