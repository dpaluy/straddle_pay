# frozen_string_literal: true

module StraddlePay
  module Resources
    class Charges < Base
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

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/charges/#{id}", headers: headers)
      end

      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}", options, headers: headers)
      end

      def cancel(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}/cancel", options, headers: headers)
      end

      def hold(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}/hold", options, headers: headers)
      end

      def release(id, **options)
        headers = extract_headers(options)
        @client.put("v1/charges/#{id}/release", options, headers: headers)
      end

      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/charges/#{id}/unmask", headers: headers)
      end
    end
  end
end
