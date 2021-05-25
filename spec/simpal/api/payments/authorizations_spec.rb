# frozen_string_literal: true

RSpec.describe Simpal::API::Payments::Authorizations do
  describe 'class' do
    subject { described_class }

    it { is_expected.to respond_to(:retrieve) }
    it { is_expected.to respond_to(:reauthorize) }
    it { is_expected.to respond_to(:capture) }
    it { is_expected.to respond_to(:void) }
  end
end
