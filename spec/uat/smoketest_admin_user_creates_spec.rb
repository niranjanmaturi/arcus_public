require 'rails_helper'

RSpec.feature 'Smoke Test for Creates for a user with admin role', type: :feature do
  let(:admin) { create :admin_user, role: 'admin' }

  before do
    login_user(admin)
  end

  context 'user' do
    let(:email) { Faker::Internet.email }
    let(:password) { Faker::Internet.password + 'a1' }

    AdminUser::ROLES.each do |role|
      scenario "create #{role}" do
        visit new_admin_admin_user_path

        fill_in 'Email', with: email
        fill_in 'Password', with: password, match: :prefer_exact
        fill_in 'Password confirmation', with: password, match: :prefer_exact
        select role, from: 'Role'

        click_button 'Create Admin user'
        expect(page).to have_text('Admin user was successfully created.')

        expect(AdminUser.last.email).to eq(email)
        expect(AdminUser.last.role).to eq(role)

        expect(page).to have_text('Admin User Details')
        expect(page).to have_text(email)
        expect(page).to have_text(role)
      end
    end
  end

  context 'service account' do
    let(:username) { Faker::Name.first_name }
    let(:password) { Faker::Internet.password + 'a1' }
    let(:description) { Faker::Lorem.paragraph(4) }
    let(:descriptive_name) { Faker::Lorem.sentence(8) }

    scenario 'create service account' do
      visit new_admin_service_account_path

      fill_in 'Descriptive Name', with: descriptive_name
      fill_in 'Description', with: description
      fill_in 'Username', with: username
      fill_in 'Password', with: password, match: :prefer_exact
      fill_in 'Password confirmation', with: password, match: :prefer_exact

      click_button 'Create Arcus API Account'
      expect(page).to have_text('Arcus API Account was successfully created.')

      expect(ServiceAccount.last.name).to eq(descriptive_name)
      expect(ServiceAccount.last.description).to eq(description)
      expect(ServiceAccount.last.username).to eq(username)

      expect(page).to have_text('Arcus API Account Details')
      expect(page).to have_text(descriptive_name)
      expect(page).to have_text(description)
      expect(page).to have_text(username)
    end
  end
end
