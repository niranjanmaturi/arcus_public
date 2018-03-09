require 'rails_helper'

RSpec.feature 'User Roles', type: :feature do
  let!(:admin) { create :admin_user, role: 'admin' }

  before do
    login_user(admin)
  end

  scenario 'when going to Admin Users' do
    visit admin_admin_users_path

    expect(page).to have_text(admin.email)
  end

  scenario 'creating a new user' do
    visit new_admin_admin_user_path

    expect(page.find('input#admin_user_password')).not_to be_nil
    expect(page.find('input#admin_user_password_confirmation')).not_to be_nil

    expect(page.find('input#admin_user_password')[:placeholder]).to be_nil
    expect(page.find('input#admin_user_password_confirmation')[:placeholder]).to be_nil
  end

  scenario 'editing an existing user' do
    user = AdminUser.all.sample
    visit edit_admin_admin_user_path(user)

    expect(page.find('input#admin_user_password')).not_to be_nil
    expect(page.find('input#admin_user_password_confirmation')).not_to be_nil

    expect(page.find('input#admin_user_password')[:placeholder]).to eq('********')
    expect(page.find('input#admin_user_password_confirmation')[:placeholder]).to eq('********')

    fill_in 'Email', with: 'adminchanged@example.com'
    click_button('Update Admin user')
  end

  context 'password confirmation' do
    let(:user) { AdminUser.all.sample }
    scenario 'when only filling in password' do
      visit edit_admin_admin_user_path(user)

      fill_in 'Password', with: 'asdfasdf', match: :prefer_exact
      click_button('Update Admin user')

      expect(page).to have_content('Re-enter both passwords, passwords do not match', count: 1)
    end
    scenario 'when only filling in password confirmation' do
      visit edit_admin_admin_user_path(user)

      fill_in 'Password confirmation', with: 'asdfasdf'
      click_button('Update Admin user')

      expect(page).to have_content('Re-enter both passwords, passwords do not match', count: 2)
    end
  end

  context 'blank password' do
    let(:user) { AdminUser.all.sample }
    let(:spaces_password) { ' ' * 8 }

    scenario 'when only filling in password with all spaces' do
      visit edit_admin_admin_user_path(user)

      fill_in 'Password', with: spaces_password, match: :prefer_exact
      click_button('Update Admin user')

      expect(page).to have_content('Re-enter both passwords, passwords do not match, cannot contain spaces, must contain a number 0-9, and must contain a letter a-z or A-Z', count: 1)
    end
    scenario 'when filling in password and confirmation with all spaces' do
      visit edit_admin_admin_user_path(user)

      fill_in 'Password', with: spaces_password, match: :prefer_exact
      fill_in 'Password confirmation', with: spaces_password, match: :prefer_exact
      click_button('Update Admin user')

      expect(page).to have_content('Re-enter both passwords, passwords do not match, cannot contain spaces, must contain a number 0-9, and must contain a letter a-z or A-Z', count: 1)
    end
  end
end
