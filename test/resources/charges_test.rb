# frozen_string_literal: true

require "test_helper"

class ChargesTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_create
    stub = stub_request(:post, "https://api.example.com/v1/charges")
           .with(body: hash_including({ paykey: "pk_123", amount: 10_000, currency: "usd" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123" } }))

    result = @client.charges.create(
      paykey: "pk_123", amount: 10_000, currency: "usd", description: "Test",
      payment_date: "2026-03-01", consent_type: "internet",
      device: { ip_address: "1.2.3.4" }, external_id: "ext_1", config: {}
    )
    assert_equal "ch_123", result["id"]
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/charges/ch_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123", status: "created" } }))

    result = @client.charges.get("ch_123")
    assert_equal "created", result["status"]
    assert_requested stub
  end

  def test_update
    stub = stub_request(:put, "https://api.example.com/v1/charges/ch_123")
           .with(body: hash_including({ amount: 20_000 }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123" } }))

    @client.charges.update("ch_123", amount: 20_000)
    assert_requested stub
  end

  def test_cancel
    stub = stub_request(:put, "https://api.example.com/v1/charges/ch_123/cancel")
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123", status: "cancelled" } }))

    result = @client.charges.cancel("ch_123")
    assert_equal "cancelled", result["status"]
    assert_requested stub
  end

  def test_hold
    stub = stub_request(:put, "https://api.example.com/v1/charges/ch_123/hold")
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123", status: "on_hold" } }))

    @client.charges.hold("ch_123")
    assert_requested stub
  end

  def test_release
    stub = stub_request(:put, "https://api.example.com/v1/charges/ch_123/release")
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123" } }))

    @client.charges.release("ch_123")
    assert_requested stub
  end

  def test_unmask
    stub = stub_request(:get, "https://api.example.com/v1/charges/ch_123/unmask")
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123", account_number: "1234567890" } }))

    result = @client.charges.unmask("ch_123")
    assert_equal "1234567890", result["account_number"]
    assert_requested stub
  end

  def test_create_with_straddle_account_id
    stub = stub_request(:post, "https://api.example.com/v1/charges")
           .with(headers: { "Straddle-Account-Id" => "acct_456" })
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123" } }))

    @client.charges.create(
      paykey: "pk_123", amount: 10_000, currency: "usd", description: "Test",
      payment_date: "2026-03-01", consent_type: "internet",
      device: { ip_address: "1.2.3.4" }, external_id: "ext_1", config: {},
      straddle_account_id: "acct_456"
    )
    assert_requested stub
  end

  def test_resubmit
    stub = stub_request(:post, "https://api.example.com/v1/charges/ch_123/resubmit")
           .to_return(status: 200, body: JSON.generate({ data: { id: "ch_123", status: "resubmitted" } }))

    result = @client.charges.resubmit("ch_123")
    assert_equal "resubmitted", result["status"]
    assert_requested stub
  end
end
