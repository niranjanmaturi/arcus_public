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

require 'rails_helper'

RSpec.describe StepVariable, type: :model do
  it { is_expected.to have_attribute(:name) }
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_attribute(:sort_order) }
  it { is_expected.to validate_presence_of(:sort_order) }

  it { is_expected.to have_attribute(:source_type) }
  it { is_expected.to validate_presence_of(:source_type) }

  it { is_expected.to have_attribute(:value) }
  it { is_expected.to validate_presence_of(:value) }

  it { is_expected.to belong_to(:step) }
end
