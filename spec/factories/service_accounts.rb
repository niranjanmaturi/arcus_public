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

FactoryGirl.define do
  factory :service_account do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password + 'a1' }
    password_confirmation { password }
  end
end
