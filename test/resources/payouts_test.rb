# frozen_string_literal: true

require "test_helper"

class PayoutsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_create
    stub = stub_request(:post, "https://api.example.com/v1/payouts")
           .with(body: hash_including({ paykey: "pk_123", amount: 5000 }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "po_123" } }))

    result = @client.payouts.create(
      paykey: "pk_123", amount: 5000, currency: "usd", description: "Payout",
      payment_date: "2026-03-01", device: { ip_address: "1.2.3.4" }, external_id: "ext_1"
    )
    assert_equal "po_123", result["id"]
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/payouts/po_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "po_123" } }))

    @client.payouts.get("po_123")
    assert_requested stub
  end

  def test_update
    stub = stub_request(:put, "https://api.example.com/v1/payouts/po_123")
           .with(body: hash_including({ amount: 6000 }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "po_123" } }))

    @client.payouts.update("po_123", amount: 6000)
    assert_requested stub
  end

  def test_cancel_requires_reason
    stub = stub_request(:put, "https://api.example.com/v1/payouts/po_123/cancel")
           .with(body: hash_including({ reason: "Duplicate" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "po_123" } }))

    @client.payouts.cancel("po_123", reason: "Duplicate")
    assert_requested stub
  end

  def test_hold_requires_reason
    stub = stub_request(:put, "https://api.example.com/v1/payouts/po_123/hold")
           .with(body: hash_including({ reason: "Review needed" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "po_123" } }))

    @client.payouts.hold("po_123", reason: "Review needed")
    assert_requested stub
  end

  def test_release_requires_reason
    stub = stub_request(:put, "https://api.example.com/v1/payouts/po_123/release")
           .with(body: hash_including({ reason: "Approved" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "po_123" } }))

    @client.payouts.release("po_123", reason: "Approved")
    assert_requested stub
  end

  def test_unmask
    stub = stub_request(:get, "https://api.example.com/v1/payouts/po_123/unmask")
           .to_return(status: 200, body: JSON.generate({ data: { id: "po_123" } }))

    @client.payouts.unmask("po_123")
    assert_requested stub
  end
end
