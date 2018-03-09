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

class DeviceType < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false
  validate :only_one_apply_template_step
  has_many :templates
  has_many :devices
  has_many :steps, -> { order(:sort_order) }, dependent: :destroy, inverse_of: :device_type

  accepts_nested_attributes_for :steps, allow_destroy: true
  after_validation :set_step_errors

  trim_before_validation :name

  scope :disconnected, ->() { includes(:templates, :devices).where(templates: { id: nil }).where(devices: { id: nil }) }

  def disconnected
    templates.empty? && devices.empty?
  end

  def only_one_apply_template_step
    return if steps.select(&:apply_template).count == 1
    errors.add(:base, 'Device Type must have exactly one step with "Apply Template" enabled')
  end

  def set_step_errors
    return if steps.select(&:apply_template).count == 1
    steps.select(&:apply_template).each do |the_step|
      the_step.errors.add(:apply_template, 'Enable "Apply Template" for only one step')
    end
  end
end
