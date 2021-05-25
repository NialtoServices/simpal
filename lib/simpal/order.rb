# frozen_string_literal: true

module Simpal
  # @see Simpal::API::Orders
  #
  module Order
    # Create an order.
    #
    # @see Simpal::API::Orders.create
    # @param  params  [Hash]                 The parameters for the create request.
    # @param  headers [Hash]                 The custom headers to add to the request.
    # @param  client  [Simpal::Client]       The API client to make the request with.
    # @return         [Simpal::PayPalObject] An object representing the order.
    #
    def self.create(params = {}, headers: {}, client: nil)
      resource = API::Orders.create(params, headers: headers, client: client)
      PayPalObject.new(resource)
    end

    # Update an order.
    #
    # @see Simpal::API::Orders.update
    # @param  id      [String]         The ID of an existing order.
    # @param  params  [Array<Hash>]    The collection of patches to apply to the order.
    # @param  headers [Hash]           The custom headers to add to the request.
    # @param  client  [Simpal::Client] The API client to make the request with.
    # @return         [Boolean]        `true` if the order was updated, else an exception is raised.
    #
    def self.update(id, params = [], headers: {}, client: nil)
      API::Orders.update(id, params, headers: headers, client: client)
      true
    end

    # Retrieve an order.
    #
    # @see Simpal::API::Orders.retrieve
    # @param  id      [String]         The ID of an existing order.
    # @param  headers [Hash]           The custom headers to add to the request.
    # @param  client  [Simpal::Client] The API client to make the request with.
    # @return         [Hash]           A Hash representing the order.
    #
    def self.retrieve(id, headers: {}, client: nil)
      resource = API::Orders.retrieve(id, headers: headers, client: client)
      PayPalObject.new(resource)
    end

    # Authorize the payment for an order.
    #
    # @see Simpal::API::Orders.authorize
    # @param  id      [String]         The ID of an existing order.
    # @param  params  [Hash]           The parameters for the authorize request.
    # @param  headers [Hash]           The custom headers to add to the request.
    # @param  client  [Simpal::Client] The API client to make the request with.
    # @return         [Hash]           A Hash representing the order.
    #
    def self.authorize(id, params = {}, headers: {}, client: nil)
      resource = API::Orders.authorize(id, params, headers: headers, client: client)
      PayPalObject.new(resource)
    end

    # Capture the payment for an order.
    #
    # @see Simpal::API::Orders.capture
    # @param  id      [String]         The ID of an existing order.
    # @param  params  [Hash]           The parameters for the capture request.
    # @param  headers [Hash]           The custom headers to add to the request.
    # @param  client  [Simpal::Client] The API client to make the request with.
    # @return         [Hash]           A Hash representing the order.
    #
    def self.capture(id, params = {}, headers: {}, client: nil)
      resource = API::Orders.capture(id, params, headers: headers, client: client)
      PayPalObject.new(resource)
    end
  end
end
