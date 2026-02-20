# frozen_string_literal: true

module StraddlePay
  module Resources
    class Payouts < Base
      def create(paykey:, amount:, currency:, description:, payment_date:, device:, external_id:, **options)
        payload = {
          paykey: paykey, amount: amount, currency: currency, description: description,
          payment_date: payment_date, device: device, external_id: external_id, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/payouts", payload, headers: headers)
      end

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/payouts/#{id}", headers: headers)
      end

      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/payouts/#{id}", options, headers: headers)
      end

      def cancel(id, reason:, **options)
        payload = { reason: reason, **options }.compact
        headers = extract_headers(payload)
        @client.put("v1/payouts/#{id}/cancel", payload, headers: headers)
      end

      def hold(id, reason:, **options)
        payload = { reason: reason, **options }.compact
        headers = extract_headers(payload)
        @client.put("v1/payouts/#{id}/hold", payload, headers: headers)
      end

      def release(id, reason:, **options)
        payload = { reason: reason, **options }.compact
        headers = extract_headers(payload)
        @client.put("v1/payouts/#{id}/release", payload, headers: headers)
      end

      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/payouts/#{id}/unmask", headers: headers)
      end
    end
  end
end
