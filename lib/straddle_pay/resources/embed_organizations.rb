# frozen_string_literal: true

module StraddlePay
  module Resources
    class EmbedOrganizations < Base
      def create(name:, **options)
        payload = { name: name, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/organizations", payload, headers: headers)
      end

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/organizations/#{id}", headers: headers)
      end

      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/organizations", params: options, headers: headers)
      end
    end
  end
end
