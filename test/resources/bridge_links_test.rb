# frozen_string_literal: true

require "test_helper"

class BridgeLinksTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_bank_account
    stub = stub_request(:post, "https://api.example.com/v1/bridge/bank_account")
           .with(body: hash_including({
                                        customer_id: "cust_123", account_number: "1234567890",
                                        routing_number: "021000021", account_type: "checking"
                                      }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    result = @client.bridge.links.bank_account(
      customer_id: "cust_123", account_number: "1234567890",
      routing_number: "021000021", account_type: "checking"
    )
    assert_equal "pk_123", result["id"]
    assert_requested stub
  end

  def test_plaid
    stub = stub_request(:post, "https://api.example.com/v1/bridge/plaid")
           .with(body: hash_including({ customer_id: "cust_123", plaid_token: "plaid_abc" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.bridge.links.plaid(customer_id: "cust_123", plaid_token: "plaid_abc")
    assert_requested stub
  end

  def test_quiltt
    stub = stub_request(:post, "https://api.example.com/v1/bridge/quiltt")
           .with(body: hash_including({ customer_id: "cust_123", quiltt_token: "quiltt_abc" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.bridge.links.quiltt(customer_id: "cust_123", quiltt_token: "quiltt_abc")
    assert_requested stub
  end

  def test_tan
    stub = stub_request(:post, "https://api.example.com/v1/bridge/tan")
           .with(body: hash_including({
                                        customer_id: "cust_123", routing_number: "021000021",
                                        account_type: "checking", tan: "123456"
                                      }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "pk_123" } }))

    @client.bridge.links.tan(
      customer_id: "cust_123", routing_number: "021000021",
      account_type: "checking", tan: "123456"
    )
    assert_requested stub
  end
end
