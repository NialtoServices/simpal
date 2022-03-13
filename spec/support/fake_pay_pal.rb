# frozen_string_literal: true

require 'sinatra/base'

class FakePayPal < Sinatra::Base
  post '/v1/oauth2/token' do
    return render(status_code: 401) if params['grant_type'] != 'client_credentials'
    return render(status_code: 401) if basic_authorization != %w[TEST_ID TEST_SECRET]

    render json: build_oauth
  end

  get '/v2/payments/authorizations/:id' do
    return render(status_code: 401) unless bearer_authorization.is_a?(String)
    return render(status_code: 404) unless params[:id] =~ /^[A-Z0-9]{17}$/

    render json: build_authorization(id: params[:id])
  end

  post '/v2/payments/authorizations/:id/reauthorize' do
    return render(status_code: 401) unless bearer_authorization.is_a?(String)
    return render(status_code: 404) unless params[:id] =~ /^[A-Z0-9]{17}$/

    render json: build_authorization(id: params[:id])
  end

  post '/v2/payments/authorizations/:id/capture' do
    return render(status_code: 401) unless bearer_authorization.is_a?(String)
    return render(status_code: 404) unless params[:id] =~ /^[A-Z0-9]{17}$/

    render json: build_capture(id: params[:id], status: 'COMPLETED')
  end

  post '/v2/payments/authorizations/:id/void' do
    return render(status_code: 401) unless bearer_authorization.is_a?(String)
    return render(status_code: 404) unless params[:id] =~ /^[A-Z0-9]{17}$/

    render(status_code: 204)
  end

  get '/v2/payments/captures/:id' do
    return render(status_code: 401) unless bearer_authorization.is_a?(String)
    return render(status_code: 404) unless params[:id] =~ /^[A-Z0-9]{17}$/

    render json: build_capture(id: params[:id])
  end

  post '/v2/payments/captures/:id/refund' do
    return render(status_code: 401) unless bearer_authorization.is_a?(String)
    return render(status_code: 404) unless params[:id] =~ /^[A-Z0-9]{17}$/

    render json: build_refund(id: params[:id])
  end

  get '/v2/payments/refunds/:id' do
    return render(status_code: 401) unless bearer_authorization.is_a?(String)
    return render(status_code: 404) unless params[:id] =~ /^[A-Z0-9]{17}$/

    render json: build_refund(id: params[:id])
  end

  private

  def basic_authorization
    authorization = request.env['HTTP_AUTHORIZATION']
    return nil unless authorization =~ /^Basic (.*)/

    credentials = Base64.decode64(Regexp.last_match(1)).split(':')
    credentials.length == 2 ? credentials : nil
  end

  def bearer_authorization
    authorization = request.env['HTTP_AUTHORIZATION']
    return nil unless authorization =~ /^Bearer (.*)/

    Regexp.last_match(1)
  end

  def render(json: {}, status_code: 200)
    content_type(:json)
    status(status_code)
    JSON.generate(json)
  end

  def build_oauth
    {
      scope: [
        'https://api.paypal.com/v1/payments/.*',
        'https://api.paypal.com/v1/vault/credit-card',
        'https://api.paypal.com/v1/vault/credit-card/.*',
        'https://uri.paypal.com/payments/payouts',
        'https://uri.paypal.com/services/applications/webhooks',
        'https://uri.paypal.com/services/disputes/read-buyer',
        'https://uri.paypal.com/services/disputes/read-seller',
        'https://uri.paypal.com/services/disputes/update-seller',
        'https://uri.paypal.com/services/invoicing',
        'https://uri.paypal.com/services/payments/payment/authcapture',
        'https://uri.paypal.com/services/payments/realtimepayment',
        'https://uri.paypal.com/services/payments/refund',
        'https://uri.paypal.com/services/subscriptions',
        'openid'
      ],
      app_id: "APP-#{SecureRandom.alphanumeric(17).upcase}",
      access_token: 'TEST_ACCESS_TOKEN',
      token_type: 'Bearer',
      expires_in: 3600,
      nonce: SecureRandom.urlsafe_base64(60)
    }
  end

  def build_authorization(id:, status: 'CREATED')
    server_name = request.env['SERVER_NAME']
    time = DateTime.now

    {
      id: id,
      status: status,
      create_time: time,
      update_time: time,
      expiration_time: time + (60 * 60 * 12), # 12 hours from now
      amount: {
        currency: 'USD',
        value: '10.00'
      },
      seller_protection: {
        status: 'ELIGIBLE',
        dispute_categories: %w[ITEM_NOT_RECEIVED UNAUTHORIZED_TRANSACTION]
      },
      links: [
        {
          href: "https://#{server_name}/v2/payments/authorizations/#{id}",
          method: 'GET',
          rel: 'self'
        },
        {
          href: "https://#{server_name}/v2/payments/authorizations/#{id}/capture",
          method: 'POST',
          rel: 'capture'
        },
        {
          href: "https://#{server_name}/v2/payments/authorizations/#{id}/void",
          method: 'POST',
          rel: 'void'
        },
        {
          href: "https://#{server_name}/v2/payments/authorizations/#{id}/reauthorize",
          method: 'POST',
          rel: 'reauthorize'
        },
        {
          href: "https://#{server_name}/v2/checkout/orders/#{id}",
          method: 'GET',
          rel: 'up'
        }
      ]
    }
  end

  def build_capture(id:, status: 'CREATED')
    server_name = request.env['SERVER_NAME']
    time = DateTime.now

    {
      id: id,
      status: status,
      disbursement_mode: 'INSTANT',
      final_capture: true,
      create_time: time,
      update_time: time,
      expiration_time: time + (60 * 60 * 12), # 12 hours from now
      amount: {
        currency: 'USD',
        value: '10.00'
      },
      seller_protection: {
        status: 'ELIGIBLE',
        dispute_categories: %w[ITEM_NOT_RECEIVED UNAUTHORIZED_TRANSACTION]
      },
      seller_receivable_breakdown: {
        gross_amount: {
          currency_code: 'USD',
          value: '10.00'
        },
        net_amount: {
          currency_code: 'USD',
          value: '8.33'
        },
        paypal_fee: {
          currency_code: 'USD',
          value: '0.00'
        }
      },
      links: [
        {
          href: "https://#{server_name}/v2/payments/captures/#{id}",
          method: 'GET',
          rel: 'self'
        },
        {
          href: "https://#{server_name}/v2/payments/captures/#{id}/refund",
          method: 'POST',
          rel: 'refund'
        },
        {
          href: "https://#{server_name}/v2/checkout/orders/#{id}",
          method: 'GET',
          rel: 'up'
        }
      ]
    }
  end

  def build_refund(id:, status: 'CREATED')
    server_name = request.env['SERVER_NAME']
    time = DateTime.now

    {
      id: id,
      status: 'COMPLETED',
      links: [
        {
          href: "https://#{server_name}/v2/payments/refunds/#{id}",
          method: 'GET',
          rel: 'self'
        },
        {
          href: "https://#{server_name}/v2/payments/captures/#{id}",
          method: 'GET',
          rel: 'up'
        }
      ]
    }
  end

  def build_order(id:, status: 'CREATED', authorizations: [], captures: [], refunds: [])
    server_name = request.env['SERVER_NAME']

    {
      id: id,
      status: status,
      payer: {
        name: {
          given_name: 'John',
          surname: 'Doe'
        },
        email_address: 'john.doe@example.com',
        payer_id: SecureRandom.alphanumeric(17).upcase
      },
      purchase_units: [
        {
          references_id: SecureRandom.uuid,
          shipping: {
            address: {
              address_line_1: '2211 N First Street',
              address_line_2: 'Building 17',
              admin_area_2: 'San Jose',
              admin_area_1: 'CA',
              postal_code: '95131',
              country_code: 'US'
            }
          },
          payments: {
            authorizations: authorizations,
            captures: captures,
            refunds: refunds
          }
        }
      ],
      links: [
        {
          href: "https://#{server_name}/v2/checkout/orders/#{id}",
          method: 'GET',
          rel: 'self'
        }
      ]
    }
  end
end
