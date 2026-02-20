# frozen_string_literal: true

require "test_helper"

class EmbedOrganizationsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_create
    stub = stub_request(:post, "https://api.example.com/v1/organizations")
           .with(body: hash_including({ name: "Test Org" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "org_123" } }))

    result = @client.embed.organizations.create(name: "Test Org")
    assert_equal "org_123", result["id"]
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/organizations/org_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "org_123" } }))

    @client.embed.organizations.get("org_123")
    assert_requested stub
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/organizations")
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "org_123" }] }))

    @client.embed.organizations.list
    assert_requested stub
  end
end
