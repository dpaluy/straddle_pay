# frozen_string_literal: true

module StraddlePay
  module Resources
    class Payments < Base
      def list(**options)
        headers = extract_headers(options)
        @client.get("v1/payments", params: options, headers: headers)
      end
    end
  end
end
