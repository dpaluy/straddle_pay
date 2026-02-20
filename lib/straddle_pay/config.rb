# frozen_string_literal: true

require "logger"

module StraddlePay
  # Configuration for the StraddlePay client.
  #
  # @example
  #   StraddlePay.configure do |config|
  #     config.api_key  = "sk_test_..."
  #     config.base_url = StraddlePay::Config::PRODUCTION_URL
  #     config.logger   = Rails.logger
  #   end
  class Config
    # @return [String] Sandbox API base URL
    SANDBOX_URL = "https://sandbox.straddle.com"
    # @return [String] Production API base URL
    PRODUCTION_URL = "https://production.straddle.com"

    # @return [String, nil] API key for authentication
    attr_accessor :api_key
    # @return [String] Base URL for API requests (default: sandbox)
    attr_accessor :base_url
    # @return [Integer] Connection open timeout in seconds (default: 5)
    attr_accessor :open_timeout
    # @return [Integer] Response read timeout in seconds (default: 30)
    attr_accessor :read_timeout
    # @return [Logger] Logger instance
    attr_writer :logger

    def initialize
      @api_key = ENV.fetch("STRADDLE_API_KEY", nil)
      @base_url = ENV.fetch("STRADDLE_BASE_URL", SANDBOX_URL)
      @open_timeout = integer_or_default("STRADDLE_OPEN_TIMEOUT", 5)
      @read_timeout = integer_or_default("STRADDLE_READ_TIMEOUT", 30)
    end

    # @return [Logger] configured logger, falls back to Rails.logger or $stderr
    def logger
      @logger ||= (defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger) || Logger.new($stderr)
    end

    private

    def integer_or_default(key, default)
      Integer(ENV.fetch(key, default))
    rescue StandardError
      default
    end
  end
end
