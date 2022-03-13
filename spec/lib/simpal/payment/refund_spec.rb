# frozen_string_literal: true

RSpec.describe Simpal::Payment::Refund do
  describe 'class' do
    subject { described_class }

    it { is_expected.to respond_to(:retrieve) }
  end
end
