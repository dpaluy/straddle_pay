# frozen_string_literal: true

module StraddlePay
  module Resources
    class Embed < Base
      def accounts              = @accounts ||= EmbedAccounts.new(@client)
      def organizations         = @organizations ||= EmbedOrganizations.new(@client)
      def representatives       = @representatives ||= EmbedRepresentatives.new(@client)
      def linked_bank_accounts  = @linked_bank_accounts ||= EmbedLinkedBankAccounts.new(@client)
    end
  end
end
