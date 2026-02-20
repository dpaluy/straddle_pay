# frozen_string_literal: true

require "test_helper"

class BridgeTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_initialize_session
    stub = stub_request(:post, "https://api.example.com/v1/bridge/initialize")
           .with(body: hash_including({ customer_id: "cust_123" }))
           .to_return(status: 200, body: JSON.generate({ data: { token: "bridge_token_abc" } }))

    result = @client.bridge.initialize_session(customer_id: "cust_123")
    assert_equal "bridge_token_abc", result["token"]
    assert_requested stub
  end

  def test_links_accessor
    assert_instance_of StraddlePay::Resources::BridgeLinks, @client.bridge.links
  end
end
