# frozen_string_literal: true

module StraddlePay
  module Resources
    # Generate reports from the Straddle API.
    class Reports < Base
      # Get total customers grouped by status.
      #
      # @param options [Hash] optional filters
      # @return [Hash] report data
      def total_customers_by_status(**options)
        headers = extract_headers(options)
        @client.post("v1/reports/total_customers_by_status", options.empty? ? nil : options, headers: headers)
      end
    end
  end
end
