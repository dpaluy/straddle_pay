# frozen_string_literal: true

module StraddlePay
  module Resources
    # Namespace for embedded account management (multi-tenant/platform use).
    # Access sub-resources via +client.embed.accounts+, +client.embed.organizations+, etc.
    class Embed < Base
      # @return [EmbedAccounts]
      def accounts              = @accounts ||= EmbedAccounts.new(@client)
      # @return [EmbedOrganizations]
      def organizations         = @organizations ||= EmbedOrganizations.new(@client)
      # @return [EmbedRepresentatives]
      def representatives       = @representatives ||= EmbedRepresentatives.new(@client)
      # @return [EmbedLinkedBankAccounts]
      def linked_bank_accounts  = @linked_bank_accounts ||= EmbedLinkedBankAccounts.new(@client)
    end
  end
end
