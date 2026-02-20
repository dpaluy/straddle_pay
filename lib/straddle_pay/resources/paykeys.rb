# frozen_string_literal: true

module StraddlePay
  module Resources
    class Paykeys < Base
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/paykeys/#{id}", headers: headers)
      end

      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/paykeys", params: options, headers: headers)
      end

      def unmasked(id, **options)
        headers = extract_headers(options)
        @client.get("v1/paykeys/#{id}/unmasked", headers: headers)
      end

      def reveal(id, **options)
        headers = extract_headers(options)
        @client.get("v1/paykeys/#{id}/reveal", headers: headers)
      end

      def cancel(id, **options)
        headers = extract_headers(options)
        @client.put("v1/paykeys/#{id}/cancel", options, headers: headers)
      end

      def review(id, **options)
        headers = extract_headers(options)
        @client.patch("v1/paykeys/#{id}/review", options, headers: headers)
      end
    end
  end
end
