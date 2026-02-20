# frozen_string_literal: true

require "test_helper"

class FundingEventsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/funding_events")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "fe_123" }] }))

    result = @client.funding_events.list
    assert_instance_of Array, result
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/funding_events/fe_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "fe_123" } }))

    result = @client.funding_events.get("fe_123")
    assert_equal "fe_123", result["id"]
    assert_requested stub
  end

  def test_simulate
    stub = stub_request(:post, "https://api.example.com/v1/funding_events/simulate")
           .with(body: hash_including({ funding_event_job_type: "charges" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "fe_456" } }))

    result = @client.funding_events.simulate(funding_event_job_type: "charges")
    assert_equal "fe_456", result["id"]
    assert_requested stub
  end
end
