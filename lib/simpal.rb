# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'json'
require 'singleton'
require 'time'

require_relative 'simpal/constants'
require_relative 'simpal/middleware/authorization'
require_relative 'simpal/middleware/headers'
require_relative 'simpal/client_error'
require_relative 'simpal/client'
require_relative 'simpal/pay_pal_object'
require_relative 'simpal/api/orders'
require_relative 'simpal/order'

# A simple, lightweight wrapper around PayPal's REST API.
#
module Simpal
  class << self
    # @return [Simpal::Client] The default client to use when performing API requests.
    #
    attr_accessor :client

    # Returns the API client to use for a set of request parameters.
    #
    # @param  client [Simpal::Client, nil] The preferred client, or `nil`.
    # @return        [Simpal::Client]      The client to make the request with.
    # @raise         [Simpal::ClientError] When an acceptable `Simpal::Client` can't be found.
    #
    def client_for(client)
      client ||= self.client
      return client if client.is_a?(Simpal::Client)

      raise ClientError, 'API client is missing. Did you forget to set `Simpal.client`?'
    end
  end
end
