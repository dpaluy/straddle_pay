# frozen_string_literal: true

require "test_helper"

class ReportsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_total_customers_by_status
    stub = stub_request(:post, "https://api.example.com/v1/reports/total_customers_by_status")
           .to_return(status: 200, body: JSON.generate({ data: { active: 10, inactive: 5 } }))

    result = @client.reports.total_customers_by_status
    assert_equal 10, result["active"]
    assert_requested stub
  end
end
