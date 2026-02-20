# frozen_string_literal: true

require "test_helper"

class FundingEventPaymentsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/funding_event_payments/fe_123")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "fp_123" }] }))

    result = @client.funding_event_payments.get("fe_123")
    assert_instance_of Array, result
    assert_requested stub
  end
end
