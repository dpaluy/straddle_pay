# frozen_string_literal: true

require "logger"

module StraddlePay
  # Configuration for the StraddlePay client.
  #
  # @example
  #   StraddlePay.configure do |config|
  #     config.api_key     = "sk_test_..."
  #     config.environment = :production
  #     config.logger      = Rails.logger
  #   end
  class Config
    ENVIRONMENTS = {
      sandbox: "https://sandbox.straddle.com",
      production: "https://production.straddle.com"
    }.freeze

    # @return [String, nil] API key for authentication
    attr_accessor :api_key
    # @return [Integer] Connection open timeout in seconds (default: 5)
    attr_accessor :open_timeout
    # @return [Integer] Response read timeout in seconds (default: 30)
    attr_accessor :read_timeout
    # @return [Logger] Logger instance
    attr_writer :logger
    # @return [String, nil] Custom base URL override (takes precedence over environment)
    attr_writer :base_url

    # @return [Symbol] API environment (:sandbox or :production)
    attr_reader :environment

    def initialize
      @api_key = ENV.fetch("STRADDLE_API_KEY", nil)
      @environment = ENV.fetch("STRADDLE_ENVIRONMENT", "sandbox").to_sym
      @base_url = ENV.fetch("STRADDLE_BASE_URL", nil)
      @open_timeout = integer_or_default("STRADDLE_OPEN_TIMEOUT", 5)
      @read_timeout = integer_or_default("STRADDLE_READ_TIMEOUT", 30)
      validate_environment!
    end

    # @param value [Symbol, String] :sandbox or :production
    # @raise [ArgumentError] if value is not a known environment
    def environment=(value)
      @environment = value.to_sym
      validate_environment!
    end

    # @return [String] resolved base URL (custom override or environment-derived)
    def base_url
      @base_url || ENVIRONMENTS.fetch(@environment)
    end

    # @return [Logger] configured logger, falls back to Rails.logger or $stderr
    def logger
      @logger ||= (defined?(Rails) && Rails.respond_to?(:logger) && Rails.logger) || Logger.new($stderr)
    end

    private

    def validate_environment!
      return if ENVIRONMENTS.key?(@environment)

      raise ArgumentError,
            "Unknown environment: #{@environment}. Must be one of: #{ENVIRONMENTS.keys.join(", ")}"
    end

    def integer_or_default(key, default)
      Integer(ENV.fetch(key, default))
    rescue StandardError
      default
    end
  end
end
