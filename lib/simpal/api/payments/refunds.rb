# frozen_string_literal: true

module Simpal
  module API
    # @see https://developer.paypal.com/docs/api/payments/v2/
    #
    module Payments
      # @see https://developer.paypal.com/docs/api/payments/v2/#refunds
      #
      module Refunds
        # Retrieve a refunded payment.
        #
        # @param  id      [String]         The ID of a refunded payment.
        # @param  headers [Hash]           The custom headers to add to the request.
        # @param  client  [Simpal::Client] The API client to make the request with.
        # @return         [Hash]           A Hash representing the refunded payment.
        #
        def self.retrieve(id, headers: {}, client: nil)
          client = Simpal.client_for(client)
          response = client.connection.get("/v2/payments/refunds/#{id}", headers)
          response.body
        end
      end
    end
  end
end
