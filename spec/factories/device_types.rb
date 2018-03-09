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

FactoryGirl.define do
  factory :device_type do
    sequence(:name) { |n| "#{Faker::Company.buzzword.downcase}-#{n}" }
    steps { [ build(:step) ] }
  end
end
