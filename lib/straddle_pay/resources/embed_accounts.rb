# frozen_string_literal: true

module StraddlePay
  module Resources
    class EmbedAccounts < Base
      def create(organization_id:, account_type:, business_profile:, access_level:, **options)
        payload = {
          organization_id: organization_id, account_type: account_type,
          business_profile: business_profile, access_level: access_level, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/accounts", payload, headers: headers)
      end

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/accounts/#{id}", headers: headers)
      end

      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/accounts", params: options, headers: headers)
      end

      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/accounts/#{id}", options, headers: headers)
      end

      def onboard(id, terms_of_service:, **options)
        payload = { terms_of_service: terms_of_service, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/accounts/#{id}/onboard", payload, headers: headers)
      end

      def simulate(id, final_status:, **options)
        payload = { final_status: final_status, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/accounts/#{id}/simulate", payload, headers: headers)
      end
    end
  end
end
