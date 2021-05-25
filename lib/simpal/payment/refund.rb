# frozen_string_literal: true

module Simpal
  # @see Simpal::API::Payments
  #
  module Payment
    # @see Simpal::API::Payments::Refunds
    #
    module Refund
      # Retrieve a refund for a payment.
      #
      # @see Simpal::API::Payments::Refunds.retrieve
      # @param  id      [String]               The ID of a refuned payment.
      # @param  headers [Hash]                 The custom headers to add to the request.
      # @param  client  [Simpal::Client]       The API client to make the request with.
      # @return         [Simpal::PayPalObject] An object representing the refunded payment.
      #
      def self.retrieve(id, headers: {}, client: nil)
        resource = API::Payments::Refunds.retrieve(id, headers: headers, client: client)
        PayPalObject.new(resource)
      end
    end
  end
end
