# frozen_string_literal: true

require "test_helper"

class PaymentsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/payments")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "pay_123" }] }))

    result = @client.payments.list
    assert_instance_of Array, result
    assert_requested stub
  end

  def test_list_with_filters
    stub = stub_request(:get, "https://api.example.com/v1/payments")
           .with(query: { customer_id: "cust_123", page_number: "1", page_size: "25" })
           .to_return(status: 200, body: JSON.generate({ data: [] }))

    @client.payments.list(customer_id: "cust_123", page_number: "1", page_size: "25")
    assert_requested stub
  end
end
