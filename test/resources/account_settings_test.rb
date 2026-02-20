# frozen_string_literal: true

require "test_helper"

class AccountSettingsTest < Minitest::Test
  include TestConfig

  def setup
    setup_config
    @client = StraddlePay::Client.new
  end

  def teardown
    teardown_config
  end

  def test_get
    stub = stub_request(:get, "https://api.example.com/v1/account_settings/acct_123")
           .to_return(status: 200, body: JSON.generate({ data: { id: "acct_123" } }))

    result = @client.account_settings.get("acct_123")
    assert_equal "acct_123", result["id"]
    assert_requested stub
  end
end
