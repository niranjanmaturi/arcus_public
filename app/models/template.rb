# == Schema Information
#
# Table name: templates
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  transformation :text(65535)      not null
#  description    :text(65535)
#  device_type_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_templates_on_device_type_id  (device_type_id)
#  index_templates_on_name            (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (device_type_id => device_types.id)
#

class Template < ApplicationRecord
  belongs_to :device_type
  has_one :request_option, dependent: :destroy
  validates_presence_of :transformation, :device_type, :name
  validates_uniqueness_of :name, case_sensitive: false
  validate :xsl_is_valid

  delegate :url, :body, :http_method, to: :request_option

  trim_before_validation :name, :description

  after_initialize :initialize_request_option

  accepts_nested_attributes_for :request_option

  def xsl_is_valid
    return if compliant_xslt
    errors.add(:transformation, 'must be valid xsl')
  end

  def compliant_xslt
    Nokogiri::XSLT(transformation.to_s.strip, &:strict)
  rescue RuntimeError
    false
  end

  # private
  def initialize_request_option
    self.request_option ||= RequestOption.new
  end
end
