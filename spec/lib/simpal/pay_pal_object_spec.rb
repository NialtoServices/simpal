# frozen_string_literal: true

RSpec.describe Simpal::PayPalObject do
  subject(:object) { described_class.new(resource) }

  let(:resource) do
    {
      id: SecureRandom.alphanumeric(10),
      amount: {
        currency_code: 'GBP',
        value: '10.00'
      },
      reference_date: Time.now.iso8601,
      create_time: Time.now.iso8601,
      links: [
        {
          href: 'http://test.host/resource',
          rel: 'self',
          method: 'GET'
        }
      ]
    }
  end

  context 'when calling an undefined method' do
    it { is_expected.to respond_to(:undefined_method) }
    it { expect(object.undefined_method).to be_nil }
  end

  describe '#initialize' do
    it 'is expected to have attributes matching the resource' do
      expect(object.id).to eq(resource[:id])
    end

    it 'is expected to transform dates into Time objects' do
      expect(object.reference_date).to be_a(Time)
    end

    it 'is expected to transform times into Time objects' do
      expect(object.create_time).to be_a(Time)
    end

    it 'is expected to transform a Hash into additional objects' do
      expect(object.amount).to be_a(described_class)
    end

    it 'is expected to transform items in an Array' do
      expect(object.links.first).to be_a(described_class)
    end

    context 'when the resource has an Array of primitives' do
      let(:resource) do
        { variants: %w[ONE TWO] }
      end

      it { expect { object }.not_to raise_exception }
    end
  end

  describe '#to_hash' do
    subject(:hash) { object.to_hash }

    it { is_expected.to be_a(Hash) }
  end
end
