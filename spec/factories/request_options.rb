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

FactoryGirl.define do
  factory :request_option do
    url { Faker::Lorem.words(3).join('/') }
    http_method { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    basic_auth { Faker::Boolean.boolean }

    headers { build_list :header, 2 }
  end
end
