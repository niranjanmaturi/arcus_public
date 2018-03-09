# == Schema Information
#
# Table name: devices
#
#  id             :integer          not null, primary key
#  base_url       :text(65535)      not null
#  name           :string(255)      not null
#  device_type_id :integer          not null
#  ssl_validation :boolean          not null
#  username       :text(65535)
#  password       :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_devices_on_device_type_id  (device_type_id)
#  index_devices_on_name            (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (device_type_id => device_types.id)
#

require 'rails_helper'

RSpec.describe Device, type: :model do
  # subject { described_class.create(:device, device_type: create(:device_type)) }

  it { is_expected.to have_attribute :base_url }
  it { is_expected.to have_attribute :username }
  it { is_expected.to have_attribute :ssl_validation }
  it { is_expected.to have_attribute :name }
  it { is_expected.to have_attribute :password }

  it { is_expected.to belong_to :device_type }

  it { is_expected.to validate_presence_of(:base_url) }
  it { is_expected.to validate_presence_of(:device_type) }
  it { is_expected.to validate_presence_of(:name) }

  context 'when model is valid' do
    subject { build(:device, device_type: create(:device_type)) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.with_message("is already in use") }
  end

  context 'when the base url is not valid' do
    subject { build(:device, base_url: nil) }

    it { is_expected.to_not be_valid }
  end

  it_behaves_like 'trims the field', :name
  it_behaves_like 'trims the field', :username
  it_behaves_like 'trims the field', :base_url

  context 'password getters and setters' do
    let(:password) { Faker::Internet.password }
    subject { build(:device) }

    it 'sets the password' do
      subject.password = password

      expect(subject.password).to eq(password)
    end
  end
end
