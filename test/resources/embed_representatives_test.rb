# frozen_string_literal: true

require "test_helper"

class EmbedRepresentativesTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_create
    stub = stub_request(:post, "https://api.example.com/v1/representatives")
           .with(body: hash_including({ account_id: "acct_123", first_name: "John" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "rep_123" } }))

    result = @client.embed.representatives.create(
      account_id: "acct_123", first_name: "John", last_name: "Doe",
      email: "john@example.com", dob: "1990-01-01", mobile_number: "+15551234567",
      relationship: "owner", ssn_last4: "1234"
    )
    assert_equal "rep_123", result["id"]
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/representatives/rep_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "rep_123" } }))

    @client.embed.representatives.get("rep_123")
    assert_requested stub
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/representatives")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "rep_123" }] }))

    @client.embed.representatives.list
    assert_requested stub
  end

  def test_update
    stub = stub_request(:put, "https://api.example.com/v1/representatives/rep_123")
           .with(body: hash_including({ first_name: "Jane" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "rep_123" } }))

    @client.embed.representatives.update("rep_123", first_name: "Jane")
    assert_requested stub
  end

  def test_unmask
    stub = stub_request(:get, "https://api.example.com/v1/representatives/rep_123/unmask")
           .to_return(status: 200, body: JSON.generate({ data: { id: "rep_123" } }))

    @client.embed.representatives.unmask("rep_123")
    assert_requested stub
  end
end
