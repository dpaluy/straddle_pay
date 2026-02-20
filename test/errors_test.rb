# frozen_string_literal: true

require "test_helper"

class ErrorsTest < Minitest::Test
  def test_error_with_status_and_body
    error = StraddlePay::Error.new("test error", status: 400, body: { "message" => "bad" })
    assert_equal "test error", error.message
    assert_equal 400, error.status
    assert_equal({ "message" => "bad" }, error.body)
  end

  def test_error_type_extraction
    body = {
      "error" => {
        "type" => "validation_error",
        "title" => "Invalid Input Data",
        "detail" => "The request contains invalid field values.",
        "items" => [{ "reference" => "customer.email", "detail" => "Email must be unique." }]
      }
    }
    error = StraddlePay::ClientError.new("HTTP 422", status: 422, body: body)
    assert_equal "validation_error", error.error_type
    assert_equal 1, error.error_items.length
    assert_equal "customer.email", error.error_items.first["reference"]
  end

  def test_error_items_defaults_to_empty_array
    error = StraddlePay::Error.new("no items", status: 500, body: { "error" => { "type" => "api_error" } })
    assert_equal [], error.error_items
  end

  def test_error_with_nil_body
    error = StraddlePay::Error.new("network issue", status: nil, body: nil)
    assert_nil error.error_type
    assert_equal [], error.error_items
  end

  def test_inheritance_hierarchy
    assert_kind_of StraddlePay::Error, StraddlePay::AuthenticationError.new
    assert_kind_of StraddlePay::Error, StraddlePay::ClientError.new
    assert_kind_of StraddlePay::Error, StraddlePay::RateLimitError.new
    assert_kind_of StraddlePay::Error, StraddlePay::ServerError.new
    assert_kind_of StraddlePay::Error, StraddlePay::NetworkError.new
    assert_kind_of StandardError, StraddlePay::Error.new
  end
end
