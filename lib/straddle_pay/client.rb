# frozen_string_literal: true

require "faraday"
require "json"

module StraddlePay
  # HTTP client for the Straddle API. Uses Faraday under the hood.
  #
  # @example
  #   client = StraddlePay::Client.new
  #   client.charges.create(paykey: "pk_abc", amount: 10_000, ...)
  class Client
    # @return [String] API key used for authentication
    attr_reader :api_key
    # @return [String] base URL for API requests
    attr_reader :base_url

    # @param api_key [String, nil] override global API key
    # @param base_url [String, nil] override global base URL
    # @param logger [Logger, nil] override global logger
    # @param open_timeout [Integer, nil] connection open timeout in seconds
    # @param read_timeout [Integer, nil] response read timeout in seconds
    # @raise [ArgumentError] if no API key is configured
    def initialize(api_key: nil, base_url: nil, logger: nil, open_timeout: nil, read_timeout: nil)
      configuration = StraddlePay.config
      @api_key      = api_key      || configuration.api_key
      @base_url     = base_url     || configuration.base_url
      @logger       = logger       || configuration.logger
      @open_timeout = open_timeout || configuration.open_timeout
      @read_timeout = read_timeout || configuration.read_timeout

      raise ArgumentError, "Missing API key for StraddlePay" if @api_key.to_s.empty?
    end

    # @return [Resources::Customers]
    def customers      = @customers ||= Resources::Customers.new(self)
    # @return [Resources::Bridge]
    def bridge         = @bridge ||= Resources::Bridge.new(self)
    # @return [Resources::Paykeys]
    def paykeys        = @paykeys ||= Resources::Paykeys.new(self)
    # @return [Resources::Charges]
    def charges        = @charges ||= Resources::Charges.new(self)
    # @return [Resources::Payouts]
    def payouts        = @payouts ||= Resources::Payouts.new(self)
    # @return [Resources::Payments]
    def payments       = @payments ||= Resources::Payments.new(self)
    # @return [Resources::FundingEvents]
    def funding_events = @funding_events ||= Resources::FundingEvents.new(self)
    # @return [Resources::Reports]
    def reports        = @reports ||= Resources::Reports.new(self)
    # @return [Resources::Embed]
    def embed          = @embed ||= Resources::Embed.new(self)

    # @param path [String] API endpoint path
    # @param params [Hash, nil] query parameters
    # @param headers [Hash] additional HTTP headers
    # @return [Hash] parsed response data
    def get(path, params: nil, headers: {})
      request(:get, path, params: params, headers: headers)
    end

    # @param path [String] API endpoint path
    # @param body [Hash, nil] request body (JSON-encoded)
    # @param headers [Hash] additional HTTP headers
    # @return [Hash] parsed response data
    def post(path, body = nil, headers: {})
      request(:post, path, body: body, headers: headers)
    end

    # @param path [String] API endpoint path
    # @param body [Hash, nil] request body (JSON-encoded)
    # @param headers [Hash] additional HTTP headers
    # @return [Hash] parsed response data
    def put(path, body = nil, headers: {})
      request(:put, path, body: body, headers: headers)
    end

    # @param path [String] API endpoint path
    # @param body [Hash, nil] request body (JSON-encoded)
    # @param headers [Hash] additional HTTP headers
    # @return [Hash] parsed response data
    def patch(path, body = nil, headers: {})
      request(:patch, path, body: body, headers: headers)
    end

    # @param path [String] API endpoint path
    # @param body [Hash, nil] request body (JSON-encoded)
    # @param headers [Hash] additional HTTP headers
    # @return [Hash] parsed response data
    def delete(path, body = nil, headers: {})
      request(:delete, path, body: body, headers: headers)
    end

    private

    def request(method, path, body: nil, params: nil, headers: {})
      response = connection.public_send(method, path) do |req|
        apply_headers(req, headers)
        apply_body(req, body) if body
        req.params.update(params) if params
      end
      log_response(method, path, response)
      handle_response(response)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
      raise NetworkError, "Network error: #{e.message}"
    end

    def connection
      @connection ||= Faraday.new(url: @base_url) do |f|
        f.options.timeout      = @read_timeout
        f.options.open_timeout = @open_timeout
        f.adapter Faraday.default_adapter
      end
    end

    def apply_headers(req, extra = {})
      req.headers["Authorization"] = "Bearer #{@api_key}"
      req.headers["Content-Type"]  = "application/json"
      req.headers["Accept"]        = "application/json"
      extra.each { |k, v| req.headers[k.to_s] = v.to_s if v }
    end

    def apply_body(req, body)
      req.headers["Content-Type"] = "application/json"
      req.body = JSON.generate(body)
    end

    def handle_response(response)
      body = parse_body(response.body)
      return unwrap_data(body) if success?(response.status)

      raise_error(response.status, body)
    end

    def unwrap_data(body)
      return body unless body.is_a?(Hash) && body.key?("data")

      body["data"]
    end

    def success?(status)
      (200..299).cover?(status)
    end

    def parse_body(body)
      return {} if body.nil? || (body.is_a?(String) && body.empty?)
      return body unless body.is_a?(String)

      JSON.parse(body)
    rescue JSON::ParserError
      body
    end

    def raise_error(status, body)
      message = error_message(status, body)
      case status
      when 401, 403 then raise AuthenticationError.new(message, status: status, body: body)
      when 400, 404, 409, 422 then raise ClientError.new(message, status: status, body: body)
      when 429 then raise RateLimitError.new(message, status: status, body: body)
      when 500..599 then raise ServerError.new(message, status: status, body: body)
      else raise Error.new(message, status: status, body: body)
      end
    end

    def error_message(status, body)
      detail = if body.is_a?(Hash)
                 err = body["error"] || {}
                 err.is_a?(Hash) ? (err["detail"] || err["title"] || err.to_json) : err.to_s
               else
                 body.to_s
               end
      "HTTP #{status}: #{detail}"
    end

    def log_response(method, path, response)
      @logger&.debug { "StraddlePay #{method.upcase} #{path} -> #{response.status}" }
    end
  end
end
