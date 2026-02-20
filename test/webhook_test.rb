# frozen_string_literal: true

require "test_helper"

class WebhookTest < Minitest::Test
  # Svix published test vector
  SECRET    = "whsec_plJ3nmyCDGBKInavdOK15jsl"
  PAYLOAD   = '{"event_type":"ping","data":{"success":true}}'
  MSG_ID    = "msg_loFOjxBNrRLzqYUf"
  TIMESTAMP = "1731705121"
  EXPECTED_SIG = "rAvfW3dJ/X/qxhsaXPOyyCGmRKsaKWcsNccKXlIktD0="

  def valid_headers(timestamp: TIMESTAMP, signature: "v1,#{EXPECTED_SIG}")
    {
      "svix-id" => MSG_ID,
      "svix-timestamp" => timestamp,
      "svix-signature" => signature
    }
  end

  def test_compute_signature_matches_test_vector
    sig = StraddlePay::Webhook::Signature.compute_signature(
      MSG_ID, TIMESTAMP, PAYLOAD, SECRET
    )
    assert_equal EXPECTED_SIG, sig
  end

  def test_valid_signature_verifies
    result = StraddlePay::Webhook::Signature.verify_header(
      PAYLOAD, valid_headers, SECRET, tolerance: nil
    )
    assert_equal true, result
  end

  def test_invalid_signature_raises
    headers = valid_headers(signature: "v1,dGhpcyBpcyBub3QgYSByZWFsIHNpZ25hdHVyZQ==")

    error = assert_raises(StraddlePay::SignatureVerificationError) do
      StraddlePay::Webhook::Signature.verify_header(PAYLOAD, headers, SECRET, tolerance: nil)
    end
    assert_match(/No matching signature/, error.message)
    assert_equal headers["svix-signature"], error.sig_header
  end

  def test_expired_timestamp_raises
    old_ts = (Time.now.to_i - 600).to_s
    headers = StraddlePay::Webhook::Signature.generate_header(
      msg_id: MSG_ID, timestamp: old_ts, payload: PAYLOAD, secret: SECRET
    )

    error = assert_raises(StraddlePay::SignatureVerificationError) do
      StraddlePay::Webhook::Signature.verify_header(PAYLOAD, headers, SECRET, tolerance: 300)
    end
    assert_match(/Timestamp outside tolerance/, error.message)
  end

  def test_future_timestamp_raises
    future_ts = (Time.now.to_i + 600).to_s
    headers = StraddlePay::Webhook::Signature.generate_header(
      msg_id: MSG_ID, timestamp: future_ts, payload: PAYLOAD, secret: SECRET
    )

    error = assert_raises(StraddlePay::SignatureVerificationError) do
      StraddlePay::Webhook::Signature.verify_header(PAYLOAD, headers, SECRET, tolerance: 300)
    end
    assert_match(/Timestamp outside tolerance/, error.message)
  end

  def test_missing_headers_raises
    error = assert_raises(StraddlePay::SignatureVerificationError) do
      StraddlePay::Webhook::Signature.verify_header(PAYLOAD, {}, SECRET, tolerance: nil)
    end
    assert_match(/Missing required/, error.message)
  end

  def test_tolerance_nil_skips_time_check
    old_ts = "1000000000"
    headers = StraddlePay::Webhook::Signature.generate_header(
      msg_id: MSG_ID, timestamp: old_ts, payload: PAYLOAD, secret: SECRET
    )

    result = StraddlePay::Webhook::Signature.verify_header(PAYLOAD, headers, SECRET, tolerance: nil)
    assert_equal true, result
  end

  def test_construct_event_returns_parsed_hash
    headers = StraddlePay::Webhook::Signature.generate_header(
      msg_id: MSG_ID, timestamp: Time.now.to_i, payload: PAYLOAD, secret: SECRET
    )

    event = StraddlePay::Webhook.construct_event(PAYLOAD, headers, SECRET)
    assert_instance_of Hash, event
    assert_equal "ping", event["event_type"]
    assert_equal true, event["data"]["success"]
  end

  def test_construct_event_raises_on_bad_signature
    headers = valid_headers(signature: "v1,dGhpcyBpcyBub3QgYSByZWFsIHNpZ25hdHVyZQ==")

    assert_raises(StraddlePay::SignatureVerificationError) do
      StraddlePay::Webhook.construct_event(PAYLOAD, headers, SECRET, tolerance: nil)
    end
  end

  def test_generate_header_produces_verifiable_headers
    headers = StraddlePay::Webhook::Signature.generate_header(
      msg_id: MSG_ID, timestamp: Time.now.to_i, payload: PAYLOAD, secret: SECRET
    )

    assert headers.key?("svix-id")
    assert headers.key?("svix-timestamp")
    assert headers.key?("svix-signature")

    result = StraddlePay::Webhook::Signature.verify_header(PAYLOAD, headers, SECRET, tolerance: nil)
    assert_equal true, result
  end

  def test_multiple_signatures_match_any_v1
    bad_sig = "v1,dGhpcyBpcyBub3QgYSByZWFsIHNpZ25hdHVyZQ=="
    good_sig = "v1,#{EXPECTED_SIG}"
    headers = valid_headers(signature: "#{bad_sig} #{good_sig}")

    result = StraddlePay::Webhook::Signature.verify_header(PAYLOAD, headers, SECRET, tolerance: nil)
    assert_equal true, result
  end

  def test_fallback_to_webhook_prefix_headers
    headers = {
      "webhook-id" => MSG_ID,
      "webhook-timestamp" => TIMESTAMP,
      "webhook-signature" => "v1,#{EXPECTED_SIG}"
    }

    result = StraddlePay::Webhook::Signature.verify_header(PAYLOAD, headers, SECRET, tolerance: nil)
    assert_equal true, result
  end

  def test_event_type_constants
    assert_equal "charge.created.v1", StraddlePay::Webhook::Events::CHARGE_CREATED_V1
    assert_equal "payout.event.v1", StraddlePay::Webhook::Events::PAYOUT_EVENT_V1
    assert_equal "customer.created.v1", StraddlePay::Webhook::Events::CUSTOMER_CREATED_V1
    assert_equal "funding_event.event.v1", StraddlePay::Webhook::Events::FUNDING_EVENT_EVENT_V1
    assert_equal "account.created.v1", StraddlePay::Webhook::Events::ACCOUNT_CREATED_V1
    assert_equal "linked_bank_account.event.v1", StraddlePay::Webhook::Events::LINKED_BANK_ACCOUNT_EVENT_V1
  end

  def test_invalid_secret_format_raises
    error = assert_raises(StraddlePay::SignatureVerificationError) do
      StraddlePay::Webhook::Signature.compute_signature(MSG_ID, TIMESTAMP, PAYLOAD, "not-valid!!!")
    end
    assert_match(/Invalid webhook secret format/, error.message)
  end

  def test_signature_verification_error_inherits_from_error
    assert_kind_of StraddlePay::Error, StraddlePay::SignatureVerificationError.new("test")
  end

  def test_signature_verification_error_stores_sig_header
    error = StraddlePay::SignatureVerificationError.new("bad sig", sig_header: "v1,abc123")
    assert_equal "v1,abc123", error.sig_header
  end
end
