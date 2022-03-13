# frozen_string_literal: true

require 'webmock/rspec'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before do
    stub_request(:any, /api-m\.(sandbox\.)?paypal\.com/).to_rack(FakePayPal)
  end
end
