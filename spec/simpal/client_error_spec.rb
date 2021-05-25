# frozen_string_literal: true

RSpec.describe Simpal::ClientError do
  subject(:error) { described_class.new }

  it { is_expected.to be_a(StandardError) }
end
