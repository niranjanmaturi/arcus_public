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

FactoryGirl.define do
  factory :step do
    name { Faker::Lorem.word }
    sort_order { Faker::Number.between(0, 10) }
    apply_template { true }
    request_option { build(:request_option) }

    step_variables { [] }
  end
end
