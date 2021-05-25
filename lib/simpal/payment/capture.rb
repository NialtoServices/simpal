# frozen_string_literal: true

module Simpal
  # @see Simpal::API::Payments
  #
  module Payment
    # @see Simpal::API::Payments::Captures
    #
    module Capture
      # Retrieve an captured payment.
      #
      # @param  id      [String]               The ID of a captured payment.
      # @param  headers [Hash]                 The custom headers to add to the request.
      # @param  client  [Simpal::Client]       The API client to make the request with.
      # @return         [Simpal::PayPalObject] An object representing the captured payment.
      #
      def self.retrieve(id, headers: {}, client: nil)
        resource = API::Payments::Captures.retrieve(id, headers: headers, client: client)
        PayPalObject.new(resource)
      end

      # Refund a captured payment.
      #
      # @param  id      [String]               The ID of a captured payment.
      # @param  params  [Hash]                 The parameters for the refund request.
      # @param  headers [Hash]                 The custom headers to add to the request.
      # @param  client  [Simpal::Client]       The API client to make the request with.
      # @return         [Simpal::PayPalObject] An object representing the refunded payment.
      #
      def self.refund(id, params = {}, headers: {}, client: nil)
        resource = API::Payments::Captures.capture(id, params, headers: headers, client: client)
        PayPalObject.new(resource)
      end
    end
  end
end
