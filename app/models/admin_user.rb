# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  email                  :text(65535)      not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)      not null
#
# Indexes
#
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class AdminUser < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :validatable, password_length: 7..255

  validates_presence_of :role
  validate :password_complexity

  crypt_keeper :email,
               encryptor: :aes_new,
               key: Rails.application.secrets.data_encryption_key,
               salt: Rails.application.secrets.data_salt

  scope :search_by_email, ->(email) { search_by_plaintext(:email, email) }

  ROLES = %w[member admin]

  def password_complexity
    return if password.nil? || password == ''
    errors.add :password, 'cannot contain spaces' if password.match(/ /)
    errors.add :password, 'must contain a number 0-9' unless password.match(/\d/)
    errors.add :password, 'must contain a letter a-z or A-Z' unless password.match(/[a-zA-Z]/)
  end

  def self.find_for_database_authentication(warden_conditions)
    search_by_email(warden_conditions[:email]).first
  end

  def role?(base_role)
    return false unless ROLES.index(role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
end
