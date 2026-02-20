# frozen_string_literal: true

require "test_helper"

class PaykeysTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/paykeys/pk_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    result = @client.paykeys.get("pk_123")
    assert_equal "pk_123", result["id"]
    assert_requested stub
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/paykeys")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "pk_123" }] }))

    result = @client.paykeys.list
    assert_instance_of Array, result
    assert_requested stub
  end

  def test_unmasked
    stub = stub_request(:get, "https://api.example.com/v1/paykeys/pk_123/unmasked")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.paykeys.unmasked("pk_123")
    assert_requested stub
  end

  def test_reveal
    stub = stub_request(:get, "https://api.example.com/v1/paykeys/pk_123/reveal")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.paykeys.reveal("pk_123")
    assert_requested stub
  end

  def test_cancel
    stub = stub_request(:put, "https://api.example.com/v1/paykeys/pk_123/cancel")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123", status: "cancelled" } }))

    @client.paykeys.cancel("pk_123")
    assert_requested stub
  end

  def test_review
    stub = stub_request(:patch, "https://api.example.com/v1/paykeys/pk_123/review")
           .with(body: hash_including({ status: "approved" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.paykeys.review("pk_123", status: "approved")
    assert_requested stub
  end

  def test_get_review
    stub = stub_request(:get, "https://api.example.com/v1/paykeys/pk_123/review")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123", status: "in_review" } }))

    result = @client.paykeys.get_review("pk_123")
    assert_equal "in_review", result["status"]
    assert_requested stub
  end

  def test_refresh_review
    stub = stub_request(:put, "https://api.example.com/v1/paykeys/pk_123/refresh_review")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.paykeys.refresh_review("pk_123")
    assert_requested stub
  end

  def test_refresh_balance
    stub = stub_request(:put, "https://api.example.com/v1/paykeys/pk_123/refresh_balance")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.paykeys.refresh_balance("pk_123")
    assert_requested stub
  end

  def test_unblock
    stub = stub_request(:patch, "https://api.example.com/v1/paykeys/pk_123/unblock")
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123", blocked: false } }))

    result = @client.paykeys.unblock("pk_123")
    assert_equal false, result["blocked"]
    assert_requested stub
  end
end
