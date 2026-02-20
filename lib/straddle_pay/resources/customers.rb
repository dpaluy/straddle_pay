# frozen_string_literal: true

module StraddlePay
  module Resources
    # Manage customers and their identity reviews.
    class Customers < Base
      # @return [CustomerReviews] customer identity review sub-resource
      def reviews = @reviews ||= CustomerReviews.new(@client)

      # Create a new customer.
      #
      # @param name [String] customer full name
      # @param type [String] "individual" or "business"
      # @param email [String] customer email
      # @param phone [String] phone in E.164 format (e.g. "+15551234567")
      # @param device [Hash] device info (must include :ip_address)
      # @return [Hash] created customer
      def create(name:, type:, email:, phone:, device:, **options)
        payload = { name: name, type: type, email: email, phone: phone, device: device, **options }.compact
        headers = extract_headers(payload)
        @client.post("v1/customers", payload, headers: headers)
      end

      # Retrieve a customer by ID.
      #
      # @param id [String] customer ID
      # @return [Hash] customer details
      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/customers/#{id}", headers: headers)
      end

      # List customers with optional pagination.
      #
      # @param options [Hash] filter/pagination params (page_number, page_size, etc.)
      # @return [Hash] paginated customer list
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/customers", params: options, headers: headers)
      end

      # Update a customer.
      #
      # @param id [String] customer ID
      # @return [Hash] updated customer
      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/customers/#{id}", options, headers: headers)
      end

      # Delete a customer.
      #
      # @param id [String] customer ID
      # @return [Hash] deletion confirmation
      def delete(id, **options)
        headers = extract_headers(options)
        @client.delete("v1/customers/#{id}", headers: headers)
      end

      # Retrieve unmasked customer details.
      #
      # @param id [String] customer ID
      # @return [Hash] unmasked customer details
      def unmasked(id, **options)
        headers = extract_headers(options)
        @client.get("v1/customers/#{id}/unmasked", headers: headers)
      end
    end
  end
end
