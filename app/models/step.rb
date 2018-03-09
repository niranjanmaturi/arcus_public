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

class Step < ApplicationRecord
  validates_presence_of :sort_order

  belongs_to :device_type
  has_one :request_option, dependent: :destroy, inverse_of: :step
  has_many :step_variables, -> { order(:sort_order) }, dependent: :destroy, inverse_of: :step

  accepts_nested_attributes_for :request_option
  accepts_nested_attributes_for :step_variables, allow_destroy: true

  after_initialize :initialize_request_option

  #private

  def initialize_request_option
    self.request_option ||= RequestOption.new
  end
end
