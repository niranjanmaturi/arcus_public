RSpec.shared_examples 'password complexity validation' do |factory_klass|
  subject { build(factory_klass, password: password) }

  context 'with good password' do
    let(:password) { 'pass567' }
    it { is_expected.to be_valid }
  end

  context 'with length 6' do
    let(:password) { 'a1' * (6 / 2) }
    it { is_expected.to be_invalid }
  end

  context 'with length 256' do
    let(:password) { 'a1' * (256 / 2) }
    it { is_expected.to be_invalid }
  end

  context 'with all letters' do
    let(:password) { 'password' }
    it { is_expected.to be_invalid }
  end

  context 'with all numbers' do
    let(:password) { '1234567' }
    it { is_expected.to be_invalid }
  end

  context 'with a space' do
    let(:password) { 'pass 67' }
    it { is_expected.to be_invalid }
  end
end
