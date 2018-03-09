require 'rails_helper'

RSpec.feature 'Smoke Test for Creates by user with member role', type: :feature do

  let(:member) { create :admin_user, role: 'member' }
  let(:device_type_name) { Faker::Lorem.word }

  before do
    login_user(member)
  end

  context 'device types' do
    scenario 'creates new device type', js: true do
      visit new_admin_device_type_path

      fill_in 'device_type_name', with: device_type_name
      click_link 'Step'
      check 'Apply template'
      click_button 'Device type'
      expect(page).to have_text('Device type was successfully created.')

      expect(DeviceType.last.name).to eq(device_type_name)

      expect(page).to have_text('Device Type Details')
      expect(page).to have_text(device_type_name)
    end
  end

  context 'devices' do
    let!(:device_type) { create :device_type, name: device_type_name }
    let(:name) { Faker::Lorem.word }
    let(:url) { Faker::Internet.url }

    scenario 'create new device' do
      visit new_admin_device_path

      select device_type.name, from: 'Device type'
      fill_in 'Name', with: name
      fill_in 'Base URL / IP', with: url

      click_button 'Create Device'
      expect(page).to have_text('Device was successfully created.')

      expect(Device.last.name).to eq(name)
      expect(Device.last.base_url).to eq(url)

      expect(page).to have_text('Device Details')
      expect(page).to have_text(name)
      expect(page).to have_text(url)
    end
  end

  context 'templates' do
    let!(:device_type) { create :device_type, name: device_type_name }
    let(:name) { Faker::Lorem.word }
    let(:transformation) { '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' }

    ['get', 'post'].each do |http_method|
      scenario "create new #{http_method} template" do
        visit new_admin_template_path

        select device_type.name, from: 'Device type'
        fill_in 'Name', with: name
        select http_method, from: 'HTTP method'
        fill_in 'Transformation', with: transformation

        click_button 'Create Template'
        expect(page).to have_text('Template was successfully created.')

        expect(Template.last.name).to eq(name)
        expect(Template.last.http_method).to eq(http_method)
        expect(Template.last.transformation).to eq(transformation)

        expect(page).to have_text('Template Details')
        expect(page).to have_text(name)
        expect(page).to have_text(http_method)
        expect(page).to have_text(transformation)
      end
    end
  end
end
