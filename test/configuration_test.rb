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
    assert_equal :sandbox, config.environment
    assert_equal "https://sandbox.straddle.com", config.base_url
    assert_equal 5, config.open_timeout
    assert_equal 30, config.read_timeout
  end

  def test_configure_with_environment
    StraddlePay.configure do |config|
      config.api_key = "configured-key"
      config.environment = :production
      config.logger = Logger.new($stdout)
    end

    assert_equal "configured-key", StraddlePay.config.api_key
    assert_equal :production, StraddlePay.config.environment
    assert_equal "https://production.straddle.com", StraddlePay.config.base_url
    assert_instance_of Logger, StraddlePay.config.logger
  end

  def test_base_url_overrides_environment
    StraddlePay.configure do |config|
      config.environment = :production
      config.base_url = "https://custom.straddle.com"
    end

    assert_equal "https://custom.straddle.com", StraddlePay.config.base_url
  end

  def test_environment_coerces_string_to_symbol
    StraddlePay.configure { |c| c.environment = "production" }
    assert_equal :production, StraddlePay.config.environment
  end

  def test_invalid_environment_raises
    assert_raises(ArgumentError) do
      StraddlePay.configure { |c| c.environment = :staging }
    end
  end

  def test_reset_configuration
    StraddlePay.configure { |c| c.api_key = "will-be-reset" }
    StraddlePay.reset_configuration!
    assert_nil StraddlePay.config.api_key
  end

  def test_env_environment_override
    ENV["STRADDLE_ENVIRONMENT"] = "production"
    StraddlePay.reset_configuration!

    assert_equal :production, StraddlePay.config.environment
    assert_equal "https://production.straddle.com", StraddlePay.config.base_url
  ensure
    ENV.delete("STRADDLE_ENVIRONMENT")
    StraddlePay.reset_configuration!
  end

  def test_env_base_url_overrides_environment
    ENV["STRADDLE_ENVIRONMENT"] = "production"
    ENV["STRADDLE_BASE_URL"] = "https://custom.straddle.com"
    StraddlePay.reset_configuration!

    assert_equal "https://custom.straddle.com", StraddlePay.config.base_url
  ensure
    ENV.delete("STRADDLE_ENVIRONMENT")
    ENV.delete("STRADDLE_BASE_URL")
    StraddlePay.reset_configuration!
  end

  def test_env_api_key_override
    ENV["STRADDLE_API_KEY"] = "env-key"
    StraddlePay.reset_configuration!

    assert_equal "env-key", StraddlePay.config.api_key
  ensure
    ENV.delete("STRADDLE_API_KEY")
    StraddlePay.reset_configuration!
  end

  def test_environments_hash
    assert_equal "https://sandbox.straddle.com", StraddlePay::Config::ENVIRONMENTS[:sandbox]
    assert_equal "https://production.straddle.com", StraddlePay::Config::ENVIRONMENTS[:production]
  end
end
