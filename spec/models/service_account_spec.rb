# == Schema Information
#
# Table name: service_accounts
#
#  id                 :integer          not null, primary key
#  username           :string(255)      default(""), not null
#  encrypted_password :string(255)      default(""), not null
#  name               :string(255)      default(""), not null
#  description        :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_service_accounts_on_username  (username) UNIQUE
#

require 'rails_helper'

RSpec.describe ServiceAccount, type: :model do
  it { is_expected.to have_attribute(:name) }
  it { is_expected.to have_attribute(:description) }
  it { is_expected.to have_attribute(:username) }

  it { is_expected.to have_db_column(:encrypted_password) }

  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password=) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:username) }

  it { is_expected.to validate_uniqueness_of(:username).case_insensitive.with_message("is already in use") }

  it_behaves_like 'trims the field', :username
  it_behaves_like 'trims the field', :name
  it_behaves_like 'trims the field', :description

  context 'password validation' do
    subject { build(:service_account) }

    it 'should validate on a new object' do
      expect(subject).to validate_presence_of :password
      expect(subject).to validate_length_of :password
    end
    it 'should validate confirmation on a new object' do
      subject.password_confirmation = 'foo'
      subject.password = 'bar'
      subject.valid?

      expect(subject.errors.messages[:password_confirmation]).to include('Re-enter both passwords, passwords do not match')
    end

    it 'should not validate when blank on an existing object' do
      subject.save
      subject.password = subject.password_confirmation = nil

      expect(subject).not_to validate_presence_of :password
      expect(subject.errors.messages[:password_confirmation]).to eq([])
    end

    it 'should validate when password is set without confirmation on an existing object' do
      subject.save
      subject.password_confirmation = 'foo'
      subject.valid?

      expect(subject.errors.messages[:password_confirmation]).to include('Re-enter both passwords, passwords do not match')

    end
  end
  context 'password validation' do
    it_should_behave_like 'password complexity validation', :service_account
  end
end
