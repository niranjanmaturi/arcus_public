require 'uri'
# == Schema Information
#
# Table name: devices
#
#  id             :integer          not null, primary key
#  base_url       :text(65535)      not null
#  name           :string(255)      not null
#  device_type_id :integer          not null
#  ssl_validation :boolean          not null
#  username       :text(65535)
#  password       :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_devices_on_device_type_id  (device_type_id)
#  index_devices_on_name            (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (device_type_id => device_types.id)
#

class Device < ApplicationRecord
  belongs_to :device_type

  validates_presence_of :base_url, :device_type, :name
  validates_uniqueness_of :name, case_sensitive: false
  validate :url_is_valid

  trim_before_validation :name, :username, :base_url

  crypt_keeper :username, :base_url, :password,
               encryptor: :aes_new,
               key: Rails.application.secrets.data_encryption_key,
               salt: Rails.application.secrets.data_salt

  attr_accessor :blank_password

  def url_is_valid
    unless compliant
      errors.add(:base_url, "must be a valid url")
    end
  end

  def blank_password
    password.nil? || password == ''
  end

  def compliant
    uri = URI.parse(base_url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
