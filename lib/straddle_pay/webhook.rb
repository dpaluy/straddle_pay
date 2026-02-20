# frozen_string_literal: true

require "openssl"
require "json"

module StraddlePay
  # Verifies webhook signatures and parses events from Straddle (Svix) webhooks.
  #
  # @example Verifying a webhook in a Rails controller
  #   event = StraddlePay::Webhook.construct_event(
  #     request.body.read,
  #     request.headers,
  #     ENV["STRADDLE_WEBHOOK_SECRET"]
  #   )
  #
  #   case event["event_type"]
  #   when StraddlePay::Webhook::Events::CHARGE_CREATED_V1
  #     handle_charge(event["data"])
  #   end
  module Webhook
    module_function

    # Verifies the webhook signature and returns the parsed event payload.
    #
    # @param payload [String] raw request body
    # @param headers [Hash, #[]] request headers (must include svix-id, svix-timestamp, svix-signature)
    # @param secret [String] webhook signing secret (e.g. "whsec_...")
    # @param tolerance [Integer, nil] max age in seconds (default 300, nil to skip)
    # @return [Hash] parsed event with string keys
    # @raise [SignatureVerificationError] if verification fails
    def construct_event(payload, headers, secret, tolerance: 300)
      Signature.verify_header(payload, headers, secret, tolerance: tolerance)
      JSON.parse(payload)
    end

    # Low-level signature verification following the Svix protocol.
    module Signature
      HEADER_PREFIXES = %w[svix webhook].freeze

      module_function

      # Verifies the webhook signature header against the payload.
      #
      # @param payload [String] raw request body
      # @param headers [Hash, #[]] request headers
      # @param secret [String] webhook signing secret
      # @param tolerance [Integer, nil] max age in seconds (nil to skip time check)
      # @return [true]
      # @raise [SignatureVerificationError] if verification fails
      def verify_header(payload, headers, secret, tolerance: nil)
        msg_id, timestamp, signature = extract_headers(headers)
        verify_timestamp(timestamp, tolerance) if tolerance
        expected = compute_signature(msg_id, timestamp, payload, secret)
        verify_signature(expected, signature)
      end

      # Computes the expected HMAC-SHA256 signature for a webhook payload.
      #
      # @param msg_id [String] the message ID
      # @param timestamp [String] Unix timestamp
      # @param payload [String] raw request body
      # @param secret [String] webhook signing secret
      # @return [String] Base64-encoded signature
      def compute_signature(msg_id, timestamp, payload, secret)
        key = decode_secret(secret)
        signed_content = "#{msg_id}.#{timestamp}.#{payload}"
        digest = OpenSSL::HMAC.digest("SHA256", key, signed_content)
        [digest].pack("m0")
      end

      # Generates Svix-compatible headers for testing.
      #
      # @param msg_id [String] message ID
      # @param timestamp [String, Integer] Unix timestamp
      # @param payload [String] raw request body
      # @param secret [String] webhook signing secret
      # @return [Hash] headers hash with svix-id, svix-timestamp, svix-signature
      def generate_header(msg_id:, timestamp:, payload:, secret:)
        ts = timestamp.to_s
        sig = compute_signature(msg_id, ts, payload, secret)
        {
          "svix-id" => msg_id,
          "svix-timestamp" => ts,
          "svix-signature" => "v1,#{sig}"
        }
      end

      # --- private helpers ---

      def extract_headers(headers)
        prefix = HEADER_PREFIXES.find { |p| header_value(headers, "#{p}-id") }
        raise SignatureVerificationError, "Missing required webhook headers" unless prefix

        msg_id    = header_value(headers, "#{prefix}-id")
        timestamp = header_value(headers, "#{prefix}-timestamp")
        signature = header_value(headers, "#{prefix}-signature")

        raise SignatureVerificationError, "Missing required webhook headers" unless msg_id && timestamp && signature

        [msg_id, timestamp, signature]
      end

      def header_value(headers, key)
        normalized = key.upcase.tr("-", "_")
        headers[key] || headers[normalized] ||
          (headers.respond_to?(:env) && headers.env["HTTP_#{normalized}"])
      end

      def verify_timestamp(timestamp, tolerance)
        ts = Integer(timestamp)
        now = Time.now.to_i
        diff = (now - ts).abs

        return if diff <= tolerance

        raise SignatureVerificationError, "Timestamp outside tolerance zone (#{diff}s > #{tolerance}s)"
      rescue ArgumentError
        raise SignatureVerificationError, "Invalid timestamp: #{timestamp}"
      end

      def verify_signature(expected_b64, signature_header)
        signatures = signature_header.split
        v1_sigs = signatures.filter_map { |s| s.delete_prefix("v1,") if s.start_with?("v1,") }

        if v1_sigs.empty?
          raise SignatureVerificationError.new("No v1 signatures found",
                                               sig_header: signature_header)
        end

        expected_bytes = expected_b64.unpack1("m0")
        return true if v1_sigs.any? { |sig| secure_compare(expected_bytes, sig) }

        raise SignatureVerificationError.new("No matching signature found",
                                             sig_header: signature_header)
      end

      def decode_secret(secret)
        key = secret.start_with?("whsec_") ? secret[6..] : secret
        key.unpack1("m0")
      rescue ArgumentError
        raise SignatureVerificationError, "Invalid webhook secret format"
      end

      def secure_compare(expected_bytes, actual_b64)
        OpenSSL.fixed_length_secure_compare(expected_bytes, actual_b64.unpack1("m0"))
      rescue ArgumentError
        false
      end

      private_class_method :extract_headers, :header_value, :verify_timestamp,
                           :verify_signature, :decode_secret, :secure_compare
    end

    # Webhook event type constants for the Straddle API.
    module Events
      # Embed
      ACCOUNT_CREATED_V1 = "account.created.v1"
      ACCOUNT_EVENT_V1 = "account.event.v1"
      REPRESENTATIVE_CREATED_V1 = "representative.created.v1"
      REPRESENTATIVE_EVENT_V1 = "representative.event.v1"
      LINKED_BANK_ACCOUNT_CREATED_V1 = "linked_bank_account.created.v1"
      LINKED_BANK_ACCOUNT_EVENT_V1 = "linked_bank_account.event.v1"
      CAPABILITY_REQUEST_CREATED_V1 = "capability_request.created.v1"
      CAPABILITY_REQUEST_EVENT_V1 = "capability_request.event.v1"

      # Core
      CUSTOMER_CREATED_V1 = "customer.created.v1"
      CUSTOMER_EVENT_V1 = "customer.event.v1"
      PAYKEY_CREATED_V1 = "paykey.created.v1"
      PAYKEY_EVENT_V1 = "paykey.event.v1"
      CHARGE_CREATED_V1 = "charge.created.v1"
      CHARGE_EVENT_V1 = "charge.event.v1"
      PAYOUT_CREATED_V1 = "payout.created.v1"
      PAYOUT_EVENT_V1 = "payout.event.v1"

      # Funding
      FUNDING_EVENT_CREATED_V1 = "funding_event.created.v1"
      FUNDING_EVENT_EVENT_V1 = "funding_event.event.v1"
    end
  end
end
