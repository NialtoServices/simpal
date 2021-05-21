# frozen_string_literal: true

RSpec.describe Simpal do
  subject { described_class }

  describe '::VERSION' do
    subject(:version) { described_class::VERSION }

    it 'is expected to be semantic' do
      expect(version).to match(/[0-9]+\.[0-9]+\.[0-9]+/)
    end
  end
end
