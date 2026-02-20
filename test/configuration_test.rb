# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    StraddlePay.reset_configuration!
  end

  def teardown
    StraddlePay.reset_configuration!
  end

  def test_defaults
    config = StraddlePay.config
    assert_nil config.api_key
    assert_equal "https://sandbox.straddle.io", config.base_url
    assert_equal 5, config.open_timeout
    assert_equal 30, config.read_timeout
  end

  def test_configure_block
    StraddlePay.configure do |config|
      config.api_key = "configured-key"
      config.base_url = "https://production.straddle.io"
      config.logger = Logger.new($stdout)
    end

    assert_equal "configured-key", StraddlePay.config.api_key
    assert_equal "https://production.straddle.io", StraddlePay.config.base_url
    assert_instance_of Logger, StraddlePay.config.logger
  end

  def test_reset_configuration
    StraddlePay.configure { |c| c.api_key = "will-be-reset" }
    StraddlePay.reset_configuration!
    assert_nil StraddlePay.config.api_key
  end

  def test_env_overrides
    ENV["STRADDLE_API_KEY"] = "env-key"
    ENV["STRADDLE_BASE_URL"] = "https://custom.straddle.io"
    StraddlePay.reset_configuration!

    assert_equal "env-key", StraddlePay.config.api_key
    assert_equal "https://custom.straddle.io", StraddlePay.config.base_url
  ensure
    ENV.delete("STRADDLE_API_KEY")
    ENV.delete("STRADDLE_BASE_URL")
    StraddlePay.reset_configuration!
  end

  def test_sandbox_and_production_urls
    assert_equal "https://sandbox.straddle.io", StraddlePay::Config::SANDBOX_URL
    assert_equal "https://production.straddle.io", StraddlePay::Config::PRODUCTION_URL
  end
end
