# frozen_string_literal: true

module Simpal
  # @see Simpal::API::Payments
  #
  module Payment
    # @see Simpal::API::Payments::Authorizations
    #
    module Authorization
      # Retrieve an authorized payment.
      #
      # @param  id      [String]               The ID of an authorized payment.
      # @param  headers [Hash]                 The custom headers to add to the request.
      # @param  client  [Simpal::Client]       The API client to make the request with.
      # @return         [Simpal::PayPalObject] An object representing the authorized payment.
      #
      def self.retrieve(id, headers: {}, client: nil)
        resource = API::Payments::Authorizations.retrieve(id, headers: headers, client: client)
        PayPalObject.new(resource)
      end

      # Capture an authorized payment.
      #
      # @param  id      [String]               The ID of an authorized payment.
      # @param  params  [Hash]                 The parameters for the capture request.
      # @param  headers [Hash]                 The custom headers to add to the request.
      # @param  client  [Simpal::Client]       The API client to make the request with.
      # @return         [Simpal::PayPalObject] An object representing the captured payment.
      #
      def self.capture(id, params = {}, headers: {}, client: nil)
        resource = API::Payments::Authorizations.capture(id, params, headers: headers, client: client)
        PayPalObject.new(resource)
      end

      # Reauthorize an authorized payment.
      #
      # @param  id      [String]               The ID of an authorized payment.
      # @param  params  [Hash]                 The parameters for the reauthorize request.
      # @param  headers [Hash]                 The custom headers to add to the request.
      # @param  client  [Simpal::Client]       The API client to make the request with.
      # @return         [Simpal::PayPalObject] An object representing the reauthorized payment.
      #
      def self.reauthorize(id, params = {}, headers: {}, client: nil)
        resource = API::Payments::Authorizations.reauthorize(id, params, headers: headers, client: client)
        PayPalObject.new(resource)
      end

      # Void an authorized payment.
      #
      # @param  id      [String]         The ID of an authorized payment.
      # @param  headers [Hash]           The custom headers to add to the request.
      # @param  client  [Simpal::Client] The API client to make the request with.
      # @return         [Boolean]        `true` if the authorization was voided, else an exception is raised.
      #
      def self.void(id, headers: {}, client: nil)
        API::Payments::Authorizations.void(id, headers: headers, client: client)
        true
      end
    end
  end
end
