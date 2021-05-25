# frozen_string_literal: true

module Simpal
  module API
    # @see https://developer.paypal.com/docs/api/payments/v2/
    #
    module Payments
      # @see https://developer.paypal.com/docs/api/payments/v2/#captures
      #
      module Captures
        # Retrieve a captured payment.
        #
        # @param  id      [String]         The ID of a captured payment.
        # @param  headers [Hash]           The custom headers to add to the request.
        # @param  client  [Simpal::Client] The API client to make the request with.
        # @return         [Hash]           A Hash representing the captured payment.
        #
        def self.retrieve(id, headers: {}, client: nil)
          client = Simpal.client_for(client)
          response = client.connection.get("/v2/payments/captures/#{id}", headers)
          response.body
        end

        # Refund a captured payment.
        #
        # @param  id      [String]         The ID of a captured payment.
        # @param  params  [Hash]           The parameters for the refund request.
        # @param  headers [Hash]           The custom headers to add to the request.
        # @param  client  [Simpal::Client] The API client to make the request with.
        # @return         [Hash]           A Hash representing the captured payment.
        #
        def self.refund(id, params = {}, headers: {}, client: nil)
          client = Simpal.client_for(client)
          response = client.connection.post("/v2/payments/captures/#{id}/refund", params, headers)
          response.body
        end
      end
    end
  end
end
