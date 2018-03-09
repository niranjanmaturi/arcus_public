require 'rails_helper'

RSpec.feature 'Portal Security', type: :feature do
  let!(:admin) { create :admin_user, role: 'admin' }
  let!(:member) { create :admin_user, role: 'member' }

  before do
    visit new_admin_user_session_path
  end

  scenario 'login attempt with incorrect password' do
    fill_in :admin_user_email, with: admin.email
    fill_in :admin_user_password, with: String

    click_button 'Login'
    expect(page).to have_text('Invalid Email or password')
  end

  scenario 'login attempt with incorrect email' do
    fill_in :admin_user_email, with: String
    fill_in :admin_user_password, with: admin.password

    click_button 'Login'
    expect(page).to have_text('Invalid Email or password')
  end

  scenario 'login successfully' do
    login_user(admin)
    expect(page).to have_text('Version')
  end

  scenario 'member can login successfully' do
    login_user(member)
    expect(page).to have_text('Version')
  end

  scenario 'member account can not create a new user' do
    login_user(member)

    visit new_admin_admin_user_path
    expect(page).to have_text 'You are not authorized'
  end

  scenario 'member account can not create a new service account' do
    login_user(member)

    visit new_admin_service_account_path
    expect(page).to have_text 'You are not authorized'
  end
end
