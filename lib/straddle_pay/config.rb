# frozen_string_literal: true

require "logger"

module StraddlePay
  class Config
    SANDBOX_URL = "https://sandbox.straddle.io"
    PRODUCTION_URL = "https://production.straddle.io"

    attr_accessor :api_key, :base_url, :open_timeout, :read_timeout
    attr_writer :logger

    def initialize
      @api_key = ENV.fetch("STRADDLE_API_KEY", nil)
      @base_url = ENV.fetch("STRADDLE_BASE_URL", SANDBOX_URL)
      @open_timeout = integer_or_default("STRADDLE_OPEN_TIMEOUT", 5)
      @read_timeout = integer_or_default("STRADDLE_READ_TIMEOUT", 30)
    end

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
