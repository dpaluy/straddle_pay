# frozen_string_literal: true

require "test_helper"

class CustomersTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_create
    stub = stub_request(:post, "https://api.example.com/v1/customers")
           .with(body: hash_including({ name: "John Doe", type: "individual", email: "john@example.com" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "cust_123" } }))

    result = @client.customers.create(
      name: "John Doe", type: "individual", email: "john@example.com",
      phone: "+15551234567", device: { ip_address: "1.2.3.4" }
    )
    assert_equal "cust_123", result["id"]
    assert_requested stub
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/customers/cust_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "cust_123", name: "John" } }))

    result = @client.customers.get("cust_123")
    assert_equal "John", result["name"]
    assert_requested stub
  end

  def test_list
    stub = stub_request(:get, "https://api.example.com/v1/customers")
           .with(query: { page_number: "1", page_size: "10" })
           .to_return(status: 200, body: JSON.generate({ data: [{ id: "cust_123" }] }))

    result = @client.customers.list(page_number: "1", page_size: "10")
    assert_instance_of Array, result
    assert_requested stub
  end

  def test_update
    stub = stub_request(:put, "https://api.example.com/v1/customers/cust_123")
           .with(body: hash_including({ name: "Jane Doe" }))
           .to_return(status: 200, body: JSON.generate({ data: { id: "cust_123" } }))

    @client.customers.update("cust_123", name: "Jane Doe")
    assert_requested stub
  end

  def test_delete
    stub = stub_request(:delete, "https://api.example.com/v1/customers/cust_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "cust_123" } }))

    @client.customers.delete("cust_123")
    assert_requested stub
  end

  def test_unmasked
    stub = stub_request(:get, "https://api.example.com/v1/customers/cust_123/unmasked")
           .to_return(status: 200, body: JSON.generate({ data: { id: "cust_123", ssn: "123-45-6789" } }))

    result = @client.customers.unmasked("cust_123")
    assert_equal "123-45-6789", result["ssn"]
    assert_requested stub
  end

  def test_reviews_accessor
    assert_instance_of StraddlePay::Resources::CustomerReviews, @client.customers.reviews
  end
end
