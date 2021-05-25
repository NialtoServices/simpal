# frozen_string_literal: true

module Simpal
  module Middleware
    # Allows the use of convenience header names which are then mapped into the real header name.
    #
    class Headers < Faraday::Middleware
      # @return [Array] The request headers which must have the 'PayPal-' prefix applied to them.
      #
      PAYPAL_HEADERS = %w[
        Request-Id
        Client-Metadata-Id
        Partner-Attribution-Id
        Auth-Assertion
      ].freeze

      def on_request(env)
        headers = env[:request_headers]
        return unless headers.is_a?(Hash)

        # Prefer full representations, instead of the minimal response by default.
        headers['Prefer'] = 'return=representation' unless headers.key?('Prefer')

        PAYPAL_HEADERS.each do |header|
          headers["PayPal-#{header}"] = headers.delete(header) if headers.key?(header)
        end

        env[:request_headers] = headers
      end
    end
  end
end
