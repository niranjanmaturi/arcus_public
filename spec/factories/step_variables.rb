# == Schema Information
#
# Table name: step_variables
#
#  id          :integer          not null, primary key
#  sort_order  :integer          not null
#  name        :string(255)      not null
#  source_type :string(255)      not null
#  value       :string(255)      not null
#  step_id     :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_step_variables_on_step_id  (step_id)
#
# Foreign Keys
#
#  fk_rails_...  (step_id => steps.id)
#

FactoryGirl.define do
  factory :step_variable do
    name { Faker::Lorem.word }
    sort_order { Faker::Number.between(0, 10) }
    source_type { Faker::Lorem.word }
    value { Faker::Lorem.words(3).join }
  end
end
