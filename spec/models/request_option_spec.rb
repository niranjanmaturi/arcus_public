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

require 'rails_helper'

describe RequestOption, type: :model do
  it { is_expected.to have_attribute(:url) }
  it { is_expected.not_to validate_presence_of(:url) }

  it { is_expected.to have_attribute(:http_method) }
  it { is_expected.not_to validate_presence_of(:http_method) }

  it { is_expected.to have_attribute(:body) }
  it { is_expected.not_to validate_presence_of(:body) }

  it { is_expected.to have_attribute(:basic_auth) }
  it { is_expected.not_to validate_presence_of(:basic_auth) }

  it { is_expected.to belong_to(:step) }
  it { is_expected.to belong_to(:template) }

  it { is_expected.to have_many(:headers).dependent(:destroy).inverse_of(:request_option) }

  context 'belongs_to' do
    context 'step' do
      it 'is optional' do
        expect do
          create :request_option, step: nil, template: build(:template)
        end.to_not raise_error
      end
    end

    context 'step' do
      it 'is optional' do
        expect do
          create :request_option, template: nil, step: build(:step)
        end.to_not raise_error
      end
    end
  end

  context 'when belongs to step' do
    context 'step' do
      it 'http_method is required' do
        expect do
          create :request_option, template: nil, step: build(:step), http_method: nil
        end.to raise_error ActiveRecord::RecordInvalid, "Validation failed: HTTP method can't be blank"
      end

      it 'basic_auth is required' do
        expect do
          create :request_option, template: nil, step: build(:step), basic_auth: nil
        end.to raise_error ActiveRecord::RecordInvalid, 'Validation failed: Basic auth is not included in the list'
      end
    end
  end


  context 'when url is not valid' do
    subject { build(:request_option, url: "#{Faker::Lorem.word} #{Faker::Lorem.word}")}

    it { is_expected.not_to be_valid }
  end

  context 'when url has a variable' do
    subject { build(:request_option, url: 'test${name}foo')}

    it { is_expected.to be_valid }
  end

  it_behaves_like 'trims the field', :url
end
