# frozen_string_literal: true

module StraddlePay
  class Error < StandardError
    attr_reader :status, :body, :error_type, :error_items

    def initialize(message = nil, status: nil, body: nil)
      error_hash = body.is_a?(Hash) ? (body["error"] || {}) : {}
      @error_type = error_hash["type"] if error_hash.is_a?(Hash)
      @error_items = (error_hash.is_a?(Hash) ? error_hash["items"] : nil) || []
      super(message)
      @status = status
      @body = body
    end
  end

  class AuthenticationError < Error; end
  class ClientError < Error; end
  class RateLimitError < Error; end
  class ServerError < Error; end
  class NetworkError < Error; end
end
