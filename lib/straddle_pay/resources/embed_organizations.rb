# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage organizations for embedded accounts.
    # Accessed via {Embed#organizations}.
    class EmbedOrganizations < Base
      # Create an organization.
      #
      # @param name [String] organization name
      # @return [Hash] created organization
      def create(name:, **options)
        payload = { name: name, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/organizations", payload, headers: headers)
      end

      # Retrieve an organization by ID.
      #
      # @param id [String] organization ID
      # @return [Hash] organization details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/organizations/#{id}", headers: headers)
      end

      # List organizations with optional filters.
      #
      # @return [Hash] paginated organization list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/organizations", params: options, headers: headers)
      end
    end
  end
end
