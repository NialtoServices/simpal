# frozen_string_literal: true

RSpec.describe Simpal::Payment::Capture do
  describe 'class' do
    subject { described_class }

    it { is_expected.to respond_to(:retrieve) }
    it { is_expected.to respond_to(:refund) }
  end
end
