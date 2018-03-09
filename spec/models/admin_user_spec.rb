# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  email                  :text(65535)      not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)      not null
#
# Indexes
#
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  it { is_expected.to have_attribute :email }
  it { is_expected.to have_attribute :encrypted_password }
  it { is_expected.to have_attribute :role }

  it { is_expected.to validate_presence_of(:role) }

  context 'ROLES' do
    it 'contains admin and member' do
      expect(AdminUser::ROLES).to eq(['member', 'admin'])
    end
  end

  context '#role?' do
    subject { create(:admin_user, role: role) }

    context 'when role matches' do
      let(:role) { 'member' }

      it 'returns true' do
        expect(subject.role?('member')).to be_truthy
      end
    end

    context 'when role is inherited' do
      let(:role) { 'admin' }

      it 'returns true' do
        expect(subject.role?('member')).to be_truthy
      end
    end

    context 'when roles do not match' do
      let(:role) { Faker::Lorem.word }

      it 'returns false' do
        expect(subject.role?(Faker::Lorem.words(2).join)).to be_falsey
      end
    end

    context 'when role is not inherited' do
      let(:role) { 'member' }

      it 'returns false' do
        expect(subject.role?('admin')).to be_falsey
      end
    end
  end

  context '#search_by_email' do
    let(:email) { Faker::Internet.email }
    let!(:good_admin_user) { create(:admin_user, email: email) }

    before do
      5.times do
        create(:admin_user, email: Faker::Internet.email)
      end
    end

    it 'returns the right admin_user' do
      returned_users = described_class.search_by_email(email)

      expect(returned_users.size).to eq(1)
      expect(returned_users.first.attributes).to eq(good_admin_user.attributes)
    end
  end

  context '.find_for_database_authentication' do
    let(:email) { Faker::Internet.email }
    let(:hash) { { email: email } }
    let(:results) { [good_admin_user, double('bad admin user 1'), double('bad admin user 2')] }
    let(:good_admin_user) { double 'admin user' }

    it 'returns the correct admin_user' do
      expect(described_class).to receive(:search_by_email).with(email).and_return results

      expect(described_class.find_for_database_authentication(hash)).to eq(good_admin_user)
    end
  end

  context 'password validation' do
    it_should_behave_like 'password complexity validation', :admin_user
  end
end
