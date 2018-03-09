require 'rails_helper'

RSpec.feature 'ServiceAccount', type: :feature do
  let!(:admin) { create :admin_user, role: 'admin' }
  let(:device) { create :device, device_type: device_type, password: device_password }
  let(:device_type) { create :device_type }
  let(:device_password) { Faker::Internet.password }

  before do
    visit new_admin_user_session_path
    fill_in :admin_user_email, with: admin.email
    fill_in :admin_user_password, with: admin.password

    click_button 'Login'
    expect(page).to have_text('Version')
  end

  context 'attempting to create a service account' do
    let(:service_account) { build :service_account }

    scenario 'works' do
      visit new_admin_service_account_path

      fill_in 'Descriptive Name', with: service_account.name
      fill_in 'Description', with: service_account.description
      fill_in 'Username', with: service_account.username
      fill_in 'service_account_password', with: service_account.password
      fill_in 'service_account_password_confirmation', with: service_account.password

      click_button 'Create Arcus API Account'

      expect(ServiceAccount.last.name).to eq(service_account.name)
      expect(ServiceAccount.last.description).to eq(service_account.description)
      expect(ServiceAccount.last.username).to eq(service_account.username)
      expect(ServiceAccount.last.valid_password?(service_account.password)).to be_truthy
    end
  end

  context 'listing service accounts' do
    before do
      5.times { |i| create :service_account, username: "#{Faker::Internet.user_name}-#{i}" }
    end

    scenario 'shows the appropriate information' do
      original_account_count = ServiceAccount.count
      service_account = create :service_account

      visit admin_service_accounts_path

      expect(page).to have_text(service_account.name)
      expect(page).to have_text(service_account.username)

      expected_count = original_account_count + 1
      expect(page).to have_text("Displaying all #{expected_count} Arcus API Accounts")
    end
  end

  context 'attempting to delete a service account' do
    scenario 'removes the service account', js: true do
      original_account_count = ServiceAccount.count
      service_account = create :service_account

      visit admin_service_accounts_path

      expect(ServiceAccount.count).to eq(original_account_count + 1)

      message = accept_confirm do
        within "tr#service_account_#{service_account.id}" do
          click_on 'Delete'
        end
      end
      expect(message).to eq('Are you sure you want to delete this?')
      expect(page).to have_css('div', text: 'Arcus API Account was successfully destroyed')
      expect(ServiceAccount.count).to eq(original_account_count)
    end
  end

  scenario 'editing an existing service account' do
    service_account = create :service_account

    visit edit_admin_service_account_path(service_account)

    fill_in 'Descriptive Name', with: Faker::Lorem.word
    fill_in 'Description', with: Faker::Lorem.sentence
    fill_in 'Username', with: Faker::Lorem.word

    click_button('Update Arcus API Account')
  end

  context 'passwords' do
    context 'editing an existing user' do
      let(:service_account) { create(:service_account) }
      let(:description) { Faker::Lorem.sentence }

      before do
        visit edit_admin_service_account_path(service_account)
      end

      scenario 'editing an existing service account' do
        expect(page.find('input#service_account_password')).not_to be_nil
        expect(page.find('input#service_account_password_confirmation')).not_to be_nil

        expect(page.find('input#service_account_password')[:placeholder]).to eq('********')
        expect(page.find('input#service_account_password_confirmation')[:placeholder]).to eq('********')
      end

      scenario 'editing an existing service account without changing password' do
        expect(page.find('input#service_account_password')).not_to be_nil

        fill_in 'Description', with: description
        click_button('Update Arcus API Account')

        expect(service_account.reload.description).to eq(description)
      end

      scenario 'changing the password succeeds' do
        expect(page.find('input#service_account_password')).not_to be_nil
        new_password = Faker::Internet.password + 'a1'

        fill_in 'Password', with: new_password, match: :prefer_exact
        fill_in 'Password confirmation', with: new_password
        click_button('Update Arcus API Account')

        expect(service_account.reload.valid_password?(new_password)).to be_truthy
      end

      scenario 'setting only the password throws the proper failure' do
        fill_in 'Password', with: 'asdfasdf', match: :prefer_exact
        click_button('Update Arcus API Account')

        expect(page).to have_content('Re-enter both passwords, passwords do not match', count: 1)
      end

      scenario 'setting only the password confirmation throws the proper failure' do
        fill_in 'Password confirmation', with: 'asdfasdf', match: :prefer_exact
        click_button('Update Arcus API Account')

        expect(page).to have_content('Re-enter both passwords, passwords do not match', count: 2)
      end
    end

    scenario 'creating a new user' do
      visit new_admin_service_account_path

      name = Faker::Lorem.word
      password = Faker::Internet.password
      username = Faker::Internet.user_name

      expect(page.find('input#service_account_password')).not_to be_nil
      expect(page.find('input#service_account_password_confirmation')).not_to be_nil

      expect(page.find('input#service_account_password')[:placeholder]).to be_nil
      expect(page.find('input#service_account_password_confirmation')[:placeholder]).to be_nil

      fill_in 'Password', with: password, match: :prefer_exact
      fill_in 'Password confirmation', with: password
      fill_in 'Name', with: name
      fill_in 'Username', with: username

      click_on('Create Arcus API Account')
      service_account = ServiceAccount.last

      expect(service_account.name).to eq(name)
      expect(service_account.username).to eq(username)
      expect(service_account.valid_password?(password)).to be_truthy
    end
  end

  context 'blank password' do
    let(:service_account) { create :service_account }
    let(:spaces_password) { ' ' * 8 }

    scenario 'when only filling in password with all spaces' do
      visit edit_admin_service_account_path(service_account)

      fill_in 'Password', with: spaces_password, match: :prefer_exact
      click_button('Update Arcus API Account')

      expect(page).to have_content('Re-enter both passwords, passwords do not match, cannot contain spaces, must contain a number 0-9, and must contain a letter a-z or A-Z', count: 1)
    end
    scenario 'when filling in password and confirmation with all spaces' do
      visit edit_admin_service_account_path(service_account)

      fill_in 'Password', with: spaces_password, match: :prefer_exact
      fill_in 'Password confirmation', with: spaces_password, match: :prefer_exact
      click_button('Update Arcus API Account')

      expect(page).to have_content('Re-enter both passwords, passwords do not match, cannot contain spaces, must contain a number 0-9, and must contain a letter a-z or A-Z', count: 1)
    end
  end
end
