# == Schema Information
#
# Table name: device_types
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_device_types_on_name  (name) UNIQUE
#

require 'rails_helper'

RSpec.describe DeviceType, type: :model do
  it { is_expected.to have_attribute :name }

  it { is_expected.to have_many(:templates) }
  it { is_expected.to have_many(:devices) }
  it { is_expected.to have_many(:steps).inverse_of(:device_type).dependent(:destroy) }

  it_behaves_like 'trims the field', :name

  context 'when the name is not valid' do
    subject { build(:device_type, name: nil) }

    it { is_expected.to_not be_valid }
  end

  context 'when the name is valid' do
    subject { build(:device_type) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'apply template validation' do
    subject { build(:device_type, steps: [step1, step2]) }
    let(:step1) { build(:step, apply_template: step1_apply) }
    let(:step2) { build(:step, apply_template: step2_apply) }
    let(:step1_apply) { false }
    let(:step2_apply) { false }

    context 'with no steps marked' do
      it { is_expected.to be_invalid }
    end

    context 'with one step marked' do
      let(:step1_apply) { true }
      it { is_expected.to be_valid }
    end

    context 'with two steps marked' do
      let(:step1_apply) { true }
      let(:step2_apply) { true }
      it { is_expected.to be_invalid }
    end
  end
end
