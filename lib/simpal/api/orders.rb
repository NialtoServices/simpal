# frozen_string_literal: true

module Simpal
  module API
    # @see https://developer.paypal.com/docs/api/orders/v2/
    #
    module Orders
      # Create an order.
      #
      # @param  params  [Hash]           The parameters for the create request.
      # @param  headers [Hash]           The custom headers to add to the request.
      # @param  client  [Simpal::Client] The API client to make the request with.
      # @return         [Hash]           A Hash representing the order.
      #
      def self.create(params = {}, headers: {}, client: nil)
        client = Simpal.client_for(client)
        response = client.connection.post('/v2/checkout/orders', params, headers)
        response.body
      end

      # Update an order.
      #
      # @param  id      [String]         The ID of an existing order.
      # @param  params  [Array<Hash>]    The collection of patches to apply to the order.
      # @param  headers [Hash]           The custom headers to add to the request.
      # @param  client  [Simpal::Client] The API client to make the request with.
      # @return         [Hash]           An empty hash.
      #
      def self.update(id, params = [], headers: {}, client: nil)
        client = Simpal.client_for(client)
        response = client.connection.patch("/v2/checkout/orders/#{id}", params, headers)
        response.body
      end

      # Retrieve an order.
      #
      # @param  id      [String]         The ID of an existing order.
      # @param  headers [Hash]           The custom headers to add to the request.
      # @param  client  [Simpal::Client] The API client to make the request with.
      # @return         [Hash]           A Hash representing the order.
      #
      def self.retrieve(id, headers: {}, client: nil)
        client = Simpal.client_for(client)
        response = client.connection.get("/v2/checkout/orders/#{id}", headers)
        response.body
      end

      # Authorize the payment for an order.
      #
      # @param  id      [String]         The ID of an existing order.
      # @param  params  [Hash]           The parameters for the authorize request.
      # @param  headers [Hash]           The custom headers to add to the request.
      # @param  client  [Simpal::Client] The API client to make the request with.
      # @return         [Hash]           A Hash representing the order.
      #
      def self.authorize(id, params = {}, headers: {}, client: nil)
        client = Simpal.client_for(client)
        response = client.connection.post("/v2/checkout/orders/#{id}/authorize", params, headers)
        response.body
      end

      # Capture the payment for an order.
      #
      # @param  id      [String]         The ID of an existing order.
      # @param  params  [Hash]           The parameters for the capture request.
      # @param  headers [Hash]           The custom headers to add to the request.
      # @param  client  [Simpal::Client] The API client to make the request with.
      # @return         [Hash]           A Hash representing the order.
      #
      def self.capture(id, params = {}, headers: {}, client: nil)
        client = Simpal.client_for(client)
        response = client.connection.post("/v2/checkout/orders/#{id}/capture", params, headers)
        response.body
      end
    end
  end
end
