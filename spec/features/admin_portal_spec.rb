require 'rails_helper'

RSpec.feature 'Admin Portal', type: :feature do
  let!(:admin) { create :admin_user, role: 'admin' }

  before do
    `bin/build_pdf.rb public/arcus.pdf`

    login_user(admin)
  end

  after do
    `rm public/arcus.pdf`
  end

  scenario 'downloading documentation' do
    visit admin_root_path

    click_link 'Documentation'
    expect(page.current_path).to eq('/arcus.pdf')
  end
end
