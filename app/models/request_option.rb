# == Schema Information
#
# Table name: request_options
#
#  id          :integer          not null, primary key
#  url         :string(255)      not null
#  http_method :string(255)      not null
#  body        :text(65535)      not null
#  basic_auth  :boolean
#  step_id     :integer
#  template_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_request_options_on_step_id      (step_id) UNIQUE
#  index_request_options_on_template_id  (template_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (step_id => steps.id)
#  fk_rails_...  (template_id => templates.id)
#

class RequestOption < ApplicationRecord
  belongs_to :step, optional: true
  belongs_to :template, optional: true
  has_many :headers, dependent: :destroy, inverse_of: :request_option
  accepts_nested_attributes_for :headers, allow_destroy: true
  trim_before_validation :url
  validate :validate_url
  validates_presence_of :http_method, if: :step
  validates_inclusion_of :basic_auth, in: [true, false], if: :step

  def validate_url
    return if compliant_url?
    errors.add(:url, 'must be a valid relative path')
  end

  def compliant_url?
    uri = URI.parse('http://www.foo.com/' + url.to_s.gsub(/\$\{\w+\}/, 'a'))
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
