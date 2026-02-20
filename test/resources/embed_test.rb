# frozen_string_literal: true

require "test_helper"

class EmbedTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_accounts_accessor
    assert_instance_of StraddlePay::Resources::EmbedAccounts, @client.embed.accounts
  end

  def test_organizations_accessor
    assert_instance_of StraddlePay::Resources::EmbedOrganizations, @client.embed.organizations
  end

  def test_representatives_accessor
    assert_instance_of StraddlePay::Resources::EmbedRepresentatives, @client.embed.representatives
  end

  def test_linked_bank_accounts_accessor
    assert_instance_of StraddlePay::Resources::EmbedLinkedBankAccounts, @client.embed.linked_bank_accounts
  end

  def test_accessors_are_memoized
    assert_same @client.embed.accounts, @client.embed.accounts
  end
end
