# frozen_string_literal: true

module StraddlePay
  module Resources
    class EmbedLinkedBankAccounts < Base
      def create(account_id:, bank_account:, description:, **options)
        payload = {
          account_id: account_id, bank_account: bank_account,
          description: description, **options
        }.compact
        headers = extract_headers(payload)
        @client.post("v1/linked_bank_accounts", payload, headers: headers)
      end

      def get(id, **options)
        headers = extract_headers(options)
        @client.get("v1/linked_bank_accounts/#{id}", headers: headers)
      end

      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/linked_bank_accounts", params: options, headers: headers)
      end

      def update(id, **options)
        headers = extract_headers(options)
        @client.put("v1/linked_bank_accounts/#{id}", options, headers: headers)
      end

      def cancel(id, **options)
        headers = extract_headers(options)
        @client.patch("v1/linked_bank_accounts/#{id}/cancel", options.empty? ? nil : options, headers: headers)
      end

      def unmask(id, **options)
        headers = extract_headers(options)
        @client.get("v1/linked_bank_accounts/#{id}/unmask", headers: headers)
      end
    end
  end
end
