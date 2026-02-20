# frozen_string_literal: true

module StraddlePay
  module Resources
    class EmbedRepresentatives < Base
      def create(account_id:, first_name:, last_name:, email:, dob:, mobile_number:, relationship:, ssn_last4:,
                 **options)
        payload = {
          account_id: account_id, first_name: first_name, last_name: last_name,
          email: email, dob: dob, mobile_number: mobile_number,
          relationship: relationship, ssn_last4: ssn_last4, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/representatives", payload, headers: headers)
      end

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/representatives/#{id}", headers: headers)
      end

      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/representatives", params: options, headers: headers)
      end

      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/representatives/#{id}", options, headers: headers)
      end

      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/representatives/#{id}/unmask", headers: headers)
      end
    end
  end
end
