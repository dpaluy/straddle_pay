# frozen_string_literal: true

require "test_helper"

class CustomerReviewsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/customers/cust_123/review")
           .to_return(status: 200, body: JSON.generate({ data: { status: "approved" } }))

    result = @client.customers.reviews.get("cust_123")
    assert_equal "approved", result["status"]
    assert_requested stub
  end

  def test_decision
    stub = stub_request(:patch, "https://api.example.com/v1/customers/cust_123/review")
           .with(body: hash_including({ status: "approved" }))
           .to_return(status: 200, body: JSON.generate({ data: { status: "approved" } }))

    @client.customers.reviews.decision("cust_123", status: "approved")
    assert_requested stub
  end

  def test_refresh
    stub = stub_request(:put, "https://api.example.com/v1/customers/cust_123/refresh_review")
           .to_return(status: 200, body: JSON.generate({ data: { status: "pending" } }))

    @client.customers.reviews.refresh("cust_123")
    assert_requested stub
  end
end
