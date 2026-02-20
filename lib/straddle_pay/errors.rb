# frozen_string_literal: true

module StraddlePay
  # Base error for all Straddle API errors.
  #
  # @example
  #   rescue StraddlePay::Error => e
  #     e.status      # => 422
  #     e.error_type  # => "validation_error"
  #     e.error_items # => [{"reference" => "email", "detail" => "is invalid"}]
  class Error < StandardError
    # @return [Integer, nil] HTTP status code
    attr_reader :status
    # @return [Hash, nil] full response body
    attr_reader :body
    # @return [String, nil] Straddle error type (e.g. "validation_error")
    attr_reader :error_type
    # @return [Array<Hash>] Straddle error items with reference and detail
    attr_reader :error_items

    # @param message [String, nil] error message
    # @param status [Integer, nil] HTTP status code
    # @param body [Hash, nil] parsed response body
    def initialize(message = nil, status: nil, body: nil)
      error_hash = body.is_a?(Hash) ? (body["error"] || {}) : {}
      @error_type = error_hash["type"] if error_hash.is_a?(Hash)
      @error_items = (error_hash.is_a?(Hash) ? error_hash["items"] : nil) || []
      super(message)
      @status = status
      @body = body
    end
  end

  # Raised on 401/403 responses.
  class AuthenticationError < Error; end

  # Raised on 400, 404, 409, 422 responses.
  class ClientError < Error; end

  # Raised on 429 responses. Retry with backoff.
  class RateLimitError < Error; end

  # Raised on 500+ responses.
  class ServerError < Error; end

  # Raised on timeout or connection failure.
  class NetworkError < Error; end
end
