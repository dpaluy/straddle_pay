# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "straddle_pay"

require "minitest/autorun"
require "webmock/minitest"

module TestConfig
  def setup_config
    WebMock.reset!
    StraddlePay.reset_configuration!
    StraddlePay.configure do |config|
      config.api_key = "test-key"
      config.base_url = "https://api.example.com"
      config.logger = nil
    end
  end

  def teardown_config
    WebMock.reset!
    StraddlePay.reset_configuration!
  end
end
