# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  # Initialization

  def test_raises_without_api_key
    StraddlePay.reset_configuration!
    assert_raises(ArgumentError) { StraddlePay::Client.new }
  end

  def test_uses_global_config
    assert_equal "test-key", @client.api_key
    assert_equal "https://api.example.com", @client.base_url
  end

  def test_instance_overrides_global_config
    client = StraddlePay::Client.new(api_key: "override-key", base_url: "https://override.example.com")
    assert_equal "override-key", client.api_key
    assert_equal "https://override.example.com", client.base_url
  end

  # Resource accessors

  def test_resource_accessors
    assert_instance_of StraddlePay::Resources::Customers, @client.customers
    assert_instance_of StraddlePay::Resources::Bridge, @client.bridge
    assert_instance_of StraddlePay::Resources::Paykeys, @client.paykeys
    assert_instance_of StraddlePay::Resources::Charges, @client.charges
    assert_instance_of StraddlePay::Resources::Payouts, @client.payouts
    assert_instance_of StraddlePay::Resources::Payments, @client.payments
    assert_instance_of StraddlePay::Resources::FundingEvents, @client.funding_events
    assert_instance_of StraddlePay::Resources::Reports, @client.reports
    assert_instance_of StraddlePay::Resources::Embed, @client.embed
  end

  def test_resource_accessors_are_memoized
    assert_same @client.charges, @client.charges
  end

  # Response envelope unwrapping

  def test_unwraps_data_from_envelope
    stub_request(:get, "https://api.example.com/v1/test")
      .to_return(
        status: 200,
        body: JSON.generate({
                              meta: { api_request_id: "req-123" },
                              response_type: "object",
                              data: { id: "cust_abc", name: "Test" }
                            }),
        headers: { "Content-Type" => "application/json" }
      )

    result = @client.get("v1/test")
    assert_equal "cust_abc", result["id"]
    assert_equal "Test", result["name"]
  end

  def test_returns_body_without_data_key_as_is
    stub_request(:get, "https://api.example.com/v1/raw")
      .to_return(status: 200, body: JSON.generate({ key: "value" }))

    result = @client.get("v1/raw")
    assert_equal "value", result["key"]
  end

  def test_returns_empty_hash_for_empty_body
    stub_request(:delete, "https://api.example.com/v1/empty")
      .to_return(status: 204, body: "")

    result = @client.delete("v1/empty")
    assert_equal({}, result)
  end

  # Auth headers

  def test_sends_bearer_token
    stub = stub_request(:get, "https://api.example.com/v1/auth")
           .with(headers: { "Authorization" => "Bearer test-key" })
           .to_return(status: 200, body: "{}")

    @client.get("v1/auth")
    assert_requested stub
  end

  def test_sends_json_content_type
    stub = stub_request(:post, "https://api.example.com/v1/json")
           .with(headers: { "Content-Type" => "application/json", "Accept" => "application/json" })
           .to_return(status: 200, body: "{}")

    @client.post("v1/json", { key: "value" })
    assert_requested stub
  end

  # HTTP methods

  def test_post_sends_json_body
    stub = stub_request(:post, "https://api.example.com/v1/create")
           .with(body: JSON.generate({ name: "test" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "123" } }))

    result = @client.post("v1/create", { name: "test" })
    assert_equal "123", result["id"]
    assert_requested stub
  end

  def test_get_with_query_params
    stub = stub_request(:get, "https://api.example.com/v1/list")
           .with(query: { page_number: "1", page_size: "10" })
           .to_return(status: 200, body: JSON.generate({ data: [] }))

    @client.get("v1/list", params: { page_number: "1", page_size: "10" })
    assert_requested stub
  end

  def test_put_sends_json_body
    stub = stub_request(:put, "https://api.example.com/v1/update/123")
           .with(body: JSON.generate({ name: "updated" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "123" } }))

    @client.put("v1/update/123", { name: "updated" })
    assert_requested stub
  end

  def test_patch_sends_json_body
    stub = stub_request(:patch, "https://api.example.com/v1/patch/123")
           .with(body: JSON.generate({ status: "approved" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "123" } }))

    @client.patch("v1/patch/123", { status: "approved" })
    assert_requested stub
  end

  def test_delete_request
    stub = stub_request(:delete, "https://api.example.com/v1/remove/123")
           .to_return(status: 200, body: JSON.generate({ data: { deleted: true } }))

    result = @client.delete("v1/remove/123")
    assert_equal true, result["deleted"]
    assert_requested stub
  end

  # Extra headers

  def test_passes_extra_headers
    stub = stub_request(:get, "https://api.example.com/v1/headers")
           .with(headers: { "Straddle-Account-Id" => "acct_123" })
           .to_return(status: 200, body: "{}")

    @client.get("v1/headers", headers: { "Straddle-Account-Id" => "acct_123" })
    assert_requested stub
  end

  # Error handling

  def test_401_raises_authentication_error
    stub_request(:get, "https://api.example.com/v1/auth-fail")
      .to_return(status: 401, body: JSON.generate({
                                                    error: { type: "authentication_error", detail: "Invalid API key" }
                                                  }))

    error = assert_raises(StraddlePay::AuthenticationError) { @client.get("v1/auth-fail") }
    assert_equal 401, error.status
    assert_equal "authentication_error", error.error_type
  end

  def test_403_raises_authentication_error
    stub_request(:get, "https://api.example.com/v1/forbidden")
      .to_return(status: 403, body: JSON.generate({
                                                    error: { type: "authentication_error", detail: "Insufficient permissions" }
                                                  }))

    error = assert_raises(StraddlePay::AuthenticationError) { @client.get("v1/forbidden") }
    assert_equal 403, error.status
  end

  def test_400_raises_client_error
    stub_request(:post, "https://api.example.com/v1/bad")
      .to_return(status: 400, body: JSON.generate({
                                                    error: { type: "invalid_request_error", detail: "Missing required field" }
                                                  }))

    error = assert_raises(StraddlePay::ClientError) { @client.post("v1/bad", {}) }
    assert_equal 400, error.status
  end

  def test_422_raises_client_error_with_items
    stub_request(:post, "https://api.example.com/v1/invalid")
      .to_return(status: 422, body: JSON.generate({
                                                    error: {
                                                      type: "validation_error",
                                                      detail: "Validation failed",
                                                      items: [{ reference: "email", detail: "is invalid" }]
                                                    }
                                                  }))

    error = assert_raises(StraddlePay::ClientError) { @client.post("v1/invalid", {}) }
    assert_equal 422, error.status
    assert_equal "validation_error", error.error_type
    assert_equal 1, error.error_items.length
  end

  def test_429_raises_rate_limit_error
    stub_request(:get, "https://api.example.com/v1/rate-limit")
      .to_return(status: 429, body: JSON.generate({ error: { detail: "Too many requests" } }))

    assert_raises(StraddlePay::RateLimitError) { @client.get("v1/rate-limit") }
  end

  def test_500_raises_server_error
    stub_request(:get, "https://api.example.com/v1/server-error")
      .to_return(status: 500, body: JSON.generate({ error: { detail: "Internal error" } }))

    error = assert_raises(StraddlePay::ServerError) { @client.get("v1/server-error") }
    assert_equal 500, error.status
  end

  def test_network_timeout_raises_network_error
    stub_request(:get, "https://api.example.com/v1/timeout").to_timeout

    assert_raises(StraddlePay::NetworkError) { @client.get("v1/timeout") }
  end

  def test_connection_failure_raises_network_error
    stub_request(:get, "https://api.example.com/v1/down")
      .to_raise(Faraday::ConnectionFailed.new("connection refused"))

    error = assert_raises(StraddlePay::NetworkError) { @client.get("v1/down") }
    assert_match(/connection refused/, error.message)
  end

  # JSON parse safety

  def test_handles_non_json_response_body
    stub_request(:get, "https://api.example.com/v1/html")
      .to_return(status: 200, body: "<html>not json</html>")

    result = @client.get("v1/html")
    assert_equal "<html>not json</html>", result
  end
end
