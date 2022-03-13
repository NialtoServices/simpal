# frozen_string_literal: true

RSpec.describe Simpal::API::Payments::Authorizations do
  let(:client) { Simpal::Client.new(client_id: 'TEST_ID', client_secret: 'TEST_SECRET') }

  shared_examples 'bad credentials raise an exception' do
    context 'when using bad credentials' do
      let(:client) { Simpal::Client.new(client_id: 'BAD_ID', client_secret: 'BAD_SECRET') }

      it { expect { subject }.to raise_exception(Faraday::UnauthorizedError) }
    end
  end

  describe '#retrieve' do
    subject(:retrieve) { described_class.retrieve(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it 'is expected to eq the authorization' do
      expect(retrieve).to match(hash_including('id' => id))
    end
  end

  describe '#reauthorize' do
    subject(:reauthorize) { described_class.reauthorize(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it 'is expected to eq the updated authorization' do
      expect(reauthorize).to match(hash_including('id' => id))
    end
  end

  describe '#capture' do
    subject(:capture) { described_class.capture(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it 'is expected to eq the created capture' do
      # The mocking library reuses the authorization's ID on the capture to make testing easier.
      expect(capture).to match(hash_including('id' => id, 'status' => 'COMPLETED'))
    end
  end

  describe '#void' do
    subject(:void) { described_class.void(id, client: client) }

    let(:id) { SecureRandom.alphanumeric(17).upcase }

    it_behaves_like 'bad credentials raise an exception'

    it { is_expected.to eq(true) }
  end
end
