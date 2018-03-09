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

require 'rails_helper'

RSpec.describe Header, type: :model do
  it { is_expected.to have_attribute(:name) }
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_attribute(:value) }
  it { is_expected.not_to validate_presence_of(:value) }

  it { is_expected.to belong_to(:request_option) }
end
