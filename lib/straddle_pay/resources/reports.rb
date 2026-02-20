# frozen_string_literal: true

module StraddlePay
  module Resources
    class Reports < Base
      def total_customers_by_status(**options)
        headers = extract_headers(options)
        @client.post("v1/reports/total_customers_by_status", options.empty? ? nil : options, headers: headers)
      end
    end
  end
end
