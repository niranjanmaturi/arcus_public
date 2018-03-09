# == Schema Information
#
# Table name: headers
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  value             :string(255)      not null
#  request_option_id :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_headers_on_request_option_id  (request_option_id)
#
# Foreign Keys
#
#  fk_rails_...  (request_option_id => request_options.id)
#

class Header < ApplicationRecord
  validates_presence_of :name
  belongs_to :request_option
end
