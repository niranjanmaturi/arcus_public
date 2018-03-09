# == Schema Information
#
# Table name: service_accounts
#
#  id                 :integer          not null, primary key
#  username           :string(255)      default(""), not null
#  encrypted_password :string(255)      default(""), not null
#  name               :string(255)      default(""), not null
#  description        :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_service_accounts_on_username  (username) UNIQUE
#

class ServiceAccount < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, authentication_keys: [:username]

  trim_before_validation :username, :name, :description

  validates_presence_of :username
  validates_presence_of :name
  validates_uniqueness_of :username, case_sensitive: false

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password
  validate :password_complexity

  validates_length_of       :password, within: 7..255, allow_blank: true

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def password_complexity
    return if password.nil? || password == ''
    errors.add :password, 'cannot contain spaces' if password.match(/ /)
    errors.add :password, 'must contain a number 0-9' unless password.match(/\d/)
    errors.add :password, 'must contain a letter a-z or A-Z' unless password.match(/[a-zA-Z]/)
  end
end
