# frozen_string_literal: true

RSpec.describe Simpal::Order do
  describe 'class' do
    subject { described_class }

    it { is_expected.to respond_to(:create) }
    it { is_expected.to respond_to(:update) }
    it { is_expected.to respond_to(:retrieve) }
    it { is_expected.to respond_to(:authorize) }
    it { is_expected.to respond_to(:capture) }
  end
end
