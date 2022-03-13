# frozen_string_literal: true

module Simpal
  # Provides an API client for performing requests under an account within a particular environment.
  #
  # PayPal API credentials can be obtained from the following URL:
  #   => https://developer.paypal.com/developer/applications
  #
  class Client
    # @return [String] The 'Client ID' from your PayPal account dashboard.
    #
    attr_reader :client_id

    # @return [String] The 'Client Secret' from your PayPal account dashboard.
    #
    attr_reader :client_secret

    # @return [Boolean] `true` when using the sandbox API, `false` when using the production API.
    #
    attr_reader :sandbox

    # Create a new API client.
    #
    # @parameter client_id     [String]  The 'Client ID' from your PayPal account dashboard.
    # @parameter client_secret [String]  The 'Client Secret' from your PayPal account dashboard.
    # @parameter sandbox       [Boolean] `true` when using the sandbox API, `false` when using the live API.
    #
    def initialize(client_id:, client_secret:, sandbox: false)
      @client_id = client_id
      @client_secret = client_secret
      @sandbox = sandbox
    end

    # @return [String] The URL for the PayPal API service.
    #
    def service_url
      if sandbox
        'https://api-m.sandbox.paypal.com'
      else
        'https://api-m.paypal.com'
      end
    end

    # @return [Hash] The default headers, which should be merged into every API request.
    #
    def headers
      { 'User-Agent' => "Simpal/#{Simpal::VERSION}" }
    end

    # @return [Faraday::Connection] The connection to use when executing an API request.
    #
    def connection
      @connection ||= Faraday.new(service_url, headers: headers) do |connection|
        connection.request :json

        connection.response :raise_error
        connection.response :json

        connection.use Simpal::Middleware::Headers
        connection.use Simpal::Middleware::Authorization, self

        connection.adapter :net_http
      end
    end
  end
end
