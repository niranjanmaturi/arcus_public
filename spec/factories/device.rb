# == Schema Information
#
# Table name: devices
#
#  id                 :integer          not null, primary key
#  base_url           :string(255)
#  username           :string(255)
#  encrypted_password :string(255)
#  name               :string(255)
#  ssl_validation     :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
# Foreign Keys
#

FactoryGirl.define do
  factory :device do
    base_url { "#{Faker::Internet.url}/" }
    name { Faker::Company.buzzword }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password }
    ssl_validation { Faker::Boolean.boolean }
    device_type_id { rand(100000) }
  end
end
