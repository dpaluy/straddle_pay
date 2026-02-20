# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage representatives for embedded accounts.
    # Accessed via {Embed#representatives}.
    class EmbedRepresentatives < Base
      # Create a representative.
      #
      # @param account_id [String] parent account ID
      # @param first_name [String] first name
      # @param last_name [String] last name
      # @param email [String] email address
      # @param dob [String] date of birth (YYYY-MM-DD)
      # @param mobile_number [String] phone in E.164 format
      # @param relationship [String] relationship to business (e.g. "owner")
      # @param ssn_last4 [String] last 4 digits of SSN
      # @return [Hash] created representative
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

      # Retrieve a representative by ID.
      #
      # @param id [String] representative ID
      # @return [Hash] representative details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/representatives/#{id}", headers: headers)
      end

      # List representatives with optional filters.
      #
      # @return [Hash] paginated representative list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/representatives", params: options, headers: headers)
      end

      # Update a representative.
      #
      # @param id [String] representative ID
      # @return [Hash] updated representative
      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/representatives/#{id}", options, headers: headers)
      end

      # Retrieve unmasked representative details.
      #
      # @param id [String] representative ID
      # @return [Hash] unmasked representative details
      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/representatives/#{id}/unmask", headers: headers)
      end
    end
  end
end
