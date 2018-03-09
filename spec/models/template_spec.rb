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

require 'rails_helper'

describe Template, type: :model do
  it { is_expected.to have_attribute(:name) }
  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_attribute(:description) }

  it { is_expected.to have_attribute(:transformation) }
  it { is_expected.to validate_presence_of(:transformation) }

  it { is_expected.to validate_presence_of(:device_type) }
  it { is_expected.to belong_to :device_type }

  it { is_expected.to have_one(:request_option).dependent(:destroy) }

  it_behaves_like 'trims the field', :name
  it_behaves_like 'trims the field', :description

  context 'when all fields are valid' do
    subject { build(:template, device_type: build(:device_type))}

    it { is_expected.to be_valid }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.with_message('is already in use') }
  end

  context 'when transformation is' do
    subject { build(:template, transformation: transformation)}

    context 'not valid xml' do
      let(:transformation) { '<foo></bar>' }
      it { is_expected.not_to be_valid }
    end

    context 'not xslt' do
      let(:transformation) { '<foo></foo>' }
      it { is_expected.not_to be_valid }
    end

    context 'not valid xslt' do
      let(:transformation) { '<xsl:stylesheet></xsl:stylesheet>' }
      it { is_expected.not_to be_valid }
    end

    context 'complex xslt' do
      let(:transformation) do
        <<~EOF
        <?xml version="1.0" encoding="ISO-8859-1"?>
        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
          <xsl:template match="/">
            <data>
              <xsl:for-each select="root/ip-interface/ip-interface">
                <xsl:sort select="name"/>
                <results>
                  <name><xsl:value-of select="id"/></name>
                  <displayName><xsl:value-of select="name"/></displayName>
                </results>
              </xsl:for-each>
            </data>
          </xsl:template>
        </xsl:stylesheet>
        EOF
      end
      it { is_expected.to be_valid }
    end
  end
end
