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

FactoryGirl.define do
  factory :template do
    name { Faker::Lorem.words(3).join(' ') }
    description { Faker::Lorem.paragraph }
    request_option { build(:request_option) }
    association :device_type
    transformation { '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' }
  end
end
