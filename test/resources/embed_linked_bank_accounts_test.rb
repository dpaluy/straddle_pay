# frozen_string_literal: true

require "test_helper"

class EmbedLinkedBankAccountsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_create
    stub = stub_request(:post, "https://api.example.com/v1/linked_bank_accounts")
           .with(body: hash_including({ account_id: "acct_123", description: "Primary checking" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "lba_123" } }))

    result = @client.embed.linked_bank_accounts.create(
      account_id: "acct_123",
      bank_account: { account_number: "1234567890", routing_number: "021000021" },
      description: "Primary checking"
    )
    assert_equal "lba_123", result["id"]
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/linked_bank_accounts/lba_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "lba_123" } }))

    @client.embed.linked_bank_accounts.get("lba_123")
    assert_requested stub
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/linked_bank_accounts")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "lba_123" }] }))

    @client.embed.linked_bank_accounts.list
    assert_requested stub
  end

  def test_update
    stub = stub_request(:put, "https://api.example.com/v1/linked_bank_accounts/lba_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "lba_123" } }))

    @client.embed.linked_bank_accounts.update("lba_123", description: "Updated")
    assert_requested stub
  end

  def test_cancel
    stub = stub_request(:patch, "https://api.example.com/v1/linked_bank_accounts/lba_123/cancel")
           .to_return(status: 200, body: JSON.generate({ data: { id: "lba_123", status: "cancelled" } }))

    result = @client.embed.linked_bank_accounts.cancel("lba_123")
    assert_equal "cancelled", result["status"]
    assert_requested stub
  end

  def test_unmask
    stub = stub_request(:get, "https://api.example.com/v1/linked_bank_accounts/lba_123/unmask")
           .to_return(status: 200, body: JSON.generate({ data: { id: "lba_123" } }))

    @client.embed.linked_bank_accounts.unmask("lba_123")
    assert_requested stub
  end
end
