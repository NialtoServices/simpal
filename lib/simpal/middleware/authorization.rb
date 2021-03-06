# frozen_string_literal: true

module Simpal
  module Middleware
    # Requests an OAuth2 access token for a `Simpal::Client`, adding the resulting access token into each request.
    #
    class Authorization < Faraday::Middleware
      # @return [Simpal::Client] The client which we're handling the 'Authorization' header for.
      #
      attr_reader :client

      # @return [String] The access token to include in each request.
      #
      attr_reader :access_token

      # @return [Time] The time at which the access token expires.
      #
      attr_reader :access_token_expires_at

      def initialize(app, client)
        super(app)
        @client = client
      end

      def call(request_env)
        retryable = true
        refresh_access_token

        begin
          request_env[:request_headers].merge!('Authorization' => "Bearer #{access_token}")
          super(request_env)
        rescue Faraday::UnauthorizedError
          raise unless retryable

          retryable = false
          refresh_access_token!
          retry
        end
      end

      private

      def connection
        @connection ||= Faraday.new(client.service_url, headers: client.headers) do |connection|
          connection.request :url_encoded

          connection.response :raise_error
          connection.response :json

          connection.request :authorization, :basic, client.client_id, client.client_secret
        end
      end

      def expiry_base_date_for(response)
        Time.httpdate(response.headers['date'])
      rescue StandardError
        Time.now
      end

      def refresh_access_token!
        response = connection.post('/v1/oauth2/token', grant_type: :client_credentials)
        @access_token = response.body['access_token']
        @access_token_expires_at = expiry_base_date_for(response) + response.body['expires_in'].to_i
      end

      def refresh_access_token
        return if access_token && access_token_expires_at && (access_token_expires_at - Time.now) >= 1

        refresh_access_token!
      end
    end
  end
end
