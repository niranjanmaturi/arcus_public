require 'rails_helper'

RSpec.feature 'Devices', type: :feature do
  let!(:admin) { create :admin_user, role: 'admin' }
  let!(:device) { create :device, device_type: device_type, password: device_password }
  let(:device_type) { create :device_type }
  let(:device_password) { Faker::Internet.password }

  before do
    visit new_admin_user_session_path

    fill_in :admin_user_email, with: admin.email
    fill_in :admin_user_password, with: admin.password

    click_button 'Login'
    expect(page).to have_text('Version')
  end

  context 'when devices are listed' do
    scenario 'the appropriate data is shown' do
      visit admin_devices_path

      expect(page).to have_text(device.device_type.name)
      expect(page).to have_text(device.name)
      expect(page).to have_text(device.base_url)
      expect(page).to have_text(device.username)
      expect(page).to have_text(device.password.blank? ? 'No' : 'Yes')
      expect(page).to have_text(device.ssl_validation ? 'Yes' : 'No')
    end
  end

  context 'when device already has a password' do
    let(:device_password) { Faker::Internet.password }
    let(:expected_placeholder) { '********' }

    scenario 'appears correctly and can set a blank password' do
      visit edit_admin_device_path(id: device.id)

      expect(page.find('input#device_password')[:value]).to eq('')
      expect(page.find('input#device_password')[:placeholder]).to eq(expected_placeholder)
      check('Blank password')
      click_button 'Update Device'
      expect(device.reload.password).to eq('')
    end

    scenario 'appears correctly and preserves the existing password' do
      visit edit_admin_device_path(id: device.id)

      expect(page.find('input#device_password')[:value]).to eq('')
      expect(page.find('input#device_password')[:placeholder]).to eq(expected_placeholder)
      click_button 'Update Device'
      expect(device.reload.password).to eq(device_password)
    end
  end

  context 'when device has a blank password' do
    let(:device_password) { '' }
    scenario 'should keep the blank password' do
      visit edit_admin_device_path(id: device.id)

      expect(page.find('input#device_password')[:value]).to eq('')
      expect(page.find('input#device_password')[:placeholder]).to be_nil
      expect(page.find('#device_blank_password')).to be_checked
      click_button 'Update Device'
      expect(device.reload.password).to eq('')
    end

    scenario 'allows setting a password the existing password' do
      new_password = Faker::Internet.password

      visit edit_admin_device_path(id: device.id)

      expect(page.find('input#device_password')[:value]).to eq('')
      expect(page.find('input#device_password')[:placeholder]).to be_nil
      expect(page.find('#device_blank_password')).to be_checked
      uncheck('Blank password')
      fill_in 'device_password', with: new_password
      click_button 'Update Device'
      expect(device.reload.password).to eq(new_password)
    end
  end

  context 'when viewing the list of templates for a device' do
    context 'when template does not have a parameter' do
      let!(:template) { create(:template, device_type_id: device.device_type_id) }
      let(:expected_value) { device_template_results_path(device_id: device.id, template_id: template.id, format: 'c3') }

      scenario 'link url should exclude http and https' do
        visit admin_device_path(id: device.id)

        expect(page.all(:css, 'input.results_url').count).to eq(1)
        page.all(:css, 'input.results_url').each_with_index do |elem, i|
          expect(elem[:value]).to include(expected_value)
        end
      end

      scenario 'should not have a protocol' do
        visit admin_device_path(id: device.id)

        expect(page.all(:css, 'input.results_url').count).to be > 0
        page.all(:css, 'input.results_url').each do |elem|
          expect(elem[:value]).not_to match(/^http/)
          expect(elem[:value]).not_to match(/^https/)
          expect(elem[:value]).not_to match(/\/\//)
        end
      end

      scenario 'should not have a querystring' do
        visit admin_device_path(id: device.id)

        expect(page.all(:css, 'input.results_url').count).to be > 0
        page.all(:css, 'input.results_url').each do |elem|
          expect(elem[:value]).not_to match(/\?/)
        end
      end
    end

    context 'when template has parameters' do
      let(:param_name1) { Faker::Lorem.word }
      let(:param_name2) { Faker::Lorem.words(2).join }
      let!(:template_with_param) { create(:template, device_type_id: device.device_type_id, request_option: build(:request_option, url: "${#{param_name1}}/${#{param_name2}}")) }

      scenario 'should append querystring to urls' do
        visit admin_device_path(id: device.id)

        expect(page.all(:css, 'input.results_url').count).to be > 0
        page.all(:css, 'input.results_url').each do |elem|
          expect(elem[:value]).to end_with("?#{param_name1}=${value}&#{param_name2}=${value}")
        end
      end
    end
  end
end
