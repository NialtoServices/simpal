# frozen_string_literal: true

module Simpal
  module API
    # @see https://developer.paypal.com/docs/api/payments/v2/
    #
    module Payments
      # @see https://developer.paypal.com/docs/api/payments/v2/#authorizations
      #
      module Authorizations
        # Retrieve an authorized payment.
        #
        # @param  id      [String]         The ID of an authorized payment.
        # @param  headers [Hash]           The custom headers to add to the request.
        # @param  client  [Simpal::Client] The API client to make the request with.
        # @return         [Hash]           A Hash representing the authorized payment.
        #
        def self.retrieve(id, headers: {}, client: nil)
          client = Simpal.client_for(client)
          response = client.connection.get("/v2/payments/authorizations/#{id}", headers)
          response.body
        end

        # Capture an authorized payment.
        #
        # @param  id      [String]         The ID of an authorized payment.
        # @param  params  [Hash]           The parameters for the capture request.
        # @param  headers [Hash]           The custom headers to add to the request.
        # @param  client  [Simpal::Client] The API client to make the request with.
        # @return         [Hash]           A Hash representing the captured payment.
        #
        def self.capture(id, params = {}, headers: {}, client: nil)
          client = Simpal.client_for(client)
          response = client.connection.post("/v2/payments/authorizations/#{id}/capture", params, headers)
          response.body
        end

        # Reauthorize an authorized payment.
        #
        # @param  id      [String]         The ID of an authorized payment.
        # @param  params  [Hash]           The parameters for the reauthorize request.
        # @param  headers [Hash]           The custom headers to add to the request.
        # @param  client  [Simpal::Client] The API client to make the request with.
        # @return         [Hash]           A Hash representing the reauthorized payment.
        #
        def self.reauthorize(id, params = {}, headers: {}, client: nil)
          client = Simpal.client_for(client)
          response = client.connection.post("/v2/payments/authorizations/#{id}/reauthorize", params, headers)
          response.body
        end

        # Void an authorized payment.
        #
        # @param  id      [String]         The ID of an authorized payment.
        # @param  headers [Hash]           The custom headers to add to the request.
        # @param  client  [Simpal::Client] The API client to make the request with.
        # @return         [Hash]           An empty hash.
        #
        def self.void(id, headers: {}, client: nil)
          client = Simpal.client_for(client)
          response = client.connection.post("/v2/payments/authorizations/#{id}/void", nil, headers)
          response.body
        end
      end
    end
  end
end
