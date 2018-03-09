# == Schema Information
#
# Table name: steps
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  sort_order     :integer          not null
#  apply_template :boolean          not null
#  device_type_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_steps_on_device_type_id  (device_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (device_type_id => device_types.id)
#

require 'rails_helper'

RSpec.describe Step, type: :model do
  it { is_expected.to have_attribute(:name) }
  it { is_expected.not_to validate_presence_of(:name) }

  it { is_expected.to have_attribute(:sort_order) }
  it { is_expected.to validate_presence_of(:sort_order) }

  it { is_expected.to have_attribute(:apply_template) }
  it { is_expected.not_to validate_presence_of(:apply_template) }

  it { is_expected.to belong_to(:device_type) }

  it { is_expected.to have_one(:request_option).dependent(:destroy) }

  it { is_expected.to have_many(:step_variables).dependent(:destroy).inverse_of(:step) }

  context '#after_initialize' do
    let(:request_option) { build(:request_option) }

    context 'when there is no pre-existing request option' do
      before do
        expect(RequestOption).to receive(:new).and_return(request_option)
      end

      subject { described_class.new }

      it 'sets request_option' do
        expect(subject.request_option).to eq(request_option)
      end
    end

    context 'when there is a pre-existing request option' do
      subject { described_class.new(request_option: request_option) }

      it 'keeps the pre existing one' do
        expect(subject.request_option).to eq(request_option)
      end
    end
  end
end
