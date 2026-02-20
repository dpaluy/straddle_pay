# frozen_string_literal: true

module StraddlePay
  module Resources
    class Customers < Base
      def reviews = @reviews ||= CustomerReviews.new(@client)

      def create(name:, type:, email:, phone:, device:, **options)
        payload = { name: name, type: type, email: email, phone: phone, device: device, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/customers", payload, headers: headers)
      end

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/customers/#{id}", headers: headers)
      end

      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/customers", params: options, headers: headers)
      end

      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/customers/#{id}", options, headers: headers)
      end

      def delete(id, **options)
        headers = extract_headers(options)
        @client.delete("v1/customers/#{id}", headers: headers)
      end

      def unmasked(id, **options)
        headers = extract_headers(options)
        @client.get("v1/customers/#{id}/unmasked", headers: headers)
      end
    end
  end
end
