# frozen_string_literal: true

require "test_helper"

class EmbedAccountsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_create
    stub = stub_request(:post, "https://api.example.com/v1/accounts")
           .with(body: hash_including({ organization_id: "org_123", account_type: "standard" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "acct_123" } }))

    result = @client.embed.accounts.create(
      organization_id: "org_123", account_type: "standard",
      business_profile: { name: "Test Co" }, access_level: "standard"
    )
    assert_equal "acct_123", result["id"]
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/accounts/acct_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "acct_123" } }))

    @client.embed.accounts.get("acct_123")
    assert_requested stub
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/accounts")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "acct_123" }] }))

    @client.embed.accounts.list
    assert_requested stub
  end

  def test_update
    stub = stub_request(:put, "https://api.example.com/v1/accounts/acct_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "acct_123" } }))

    @client.embed.accounts.update("acct_123", external_id: "ext_1")
    assert_requested stub
  end

  def test_onboard
    stub = stub_request(:post, "https://api.example.com/v1/accounts/acct_123/onboard")
           .with(body: hash_including({ terms_of_service: { accepted: true } }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "acct_123" } }))

    @client.embed.accounts.onboard("acct_123", terms_of_service: { accepted: true })
    assert_requested stub
  end

  def test_simulate
    stub = stub_request(:post, "https://api.example.com/v1/accounts/acct_123/simulate")
           .with(body: hash_including({ final_status: "active" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "acct_123" } }))

    @client.embed.accounts.simulate("acct_123", final_status: "active")
    assert_requested stub
  end

  def test_capability_requests_accessor
    assert_instance_of StraddlePay::Resources::AccountCapabilityRequests, @client.embed.accounts.capability_requests
  end

  def test_capability_request_create
    stub = stub_request(:post, "https://api.example.com/v1/accounts/acct_123/capability_requests")
           .to_return(status: 200, body: JSON.generate({ data: { id: "capreq_123" } }))

    result = @client.embed.accounts.capability_requests.create("acct_123")
    assert_equal "capreq_123", result["id"]
    assert_requested stub
  end

  def test_capability_request_list
    stub = stub_request(:get, "https://api.example.com/v1/accounts/acct_123/capability_requests")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "capreq_123" }] }))

    result = @client.embed.accounts.capability_requests.list("acct_123")
    assert_instance_of Array, result
    assert_requested stub
  end
end
