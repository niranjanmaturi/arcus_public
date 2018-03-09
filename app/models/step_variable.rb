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

class StepVariable < ApplicationRecord
  validates_presence_of :name, :sort_order, :source_type, :value

  belongs_to :step
end
