require 'rails_helper'

RSpec.feature 'Device Types', type: :feature do
  let!(:admin) { create :admin_user, role: 'admin' }

  before do
    login_user(admin)
  end

  scenario 'attempting to delete a DeviceType already in use by a Device' do
    device_type = create(:device_type)
    visit admin_device_types_path

    create(:device, device_type: device_type)

    page.all('a', text: 'Delete').last.click

    expect(page).to have_text('Cannot destroy Device Types that are currently in use on Templates or Devices.')
  end

  context 'show an existing device type' do
    scenario 'with the appropriate data' do
      header = build :header
      step_variable = build :step_variable
      request_option = build :request_option, headers: [ header ]
      step = build :step, request_option: request_option, step_variables: [ step_variable ]
      device_type = create(:device_type, steps: [ step ])
      device = create :device, device_type: device_type
      template = create :template, device_type: device_type

      visit admin_device_type_path(device_type)

      expect(page).to have_text(device_type.name)
      expect(page).to have_text(device.id)
      expect(page).to have_text(device.name)
      expect(page).to have_text(device.base_url)
      expect(page).to have_text(template.id)
      expect(page).to have_text(template.name)
      expect(page).to have_text(step.name)
      expect(page).to have_text(request_option.url)
      expect(page).to have_text(request_option.http_method)
      expect(page).to have_text(request_option.body)
      expect(page).to have_text(header.name)
      expect(page).to have_text(header.value)
      expect(page).to have_text(step_variable.name)
      expect(page).to have_text(step_variable.source_type)
      expect(page).to have_text(step_variable.value)
    end

    scenario 'where the steps were created in reverse order' do
      name1 = "#{Faker::Lorem.word}-alpha"
      name2 = "#{Faker::Lorem.word}-bravo"
      step1 = build :step, sort_order: 1, apply_template: true, name: name1
      device_type = create(:device_type, steps: [step1])
      create :step, sort_order: 2, device_type: device_type, name: name2

      device_type.reload

      expect(device_type.steps.count).to eq(2)
      step1, step2 = *device_type.steps.order(:sort_order)
      step1.update_attribute :sort_order, 2
      step2.update_attribute :sort_order, 1

      visit admin_device_type_path(device_type)

      expect(page.find('.panel_contents > table > tbody > tr[id^="step_"]:nth-of-type(1)')).to have_content(name2)
      expect(page.find('.panel_contents > table > tbody > tr[id^="step_"]:nth-of-type(2)')).to have_content(name1)

    end
  end

  context 'creating a device type with steps' do
    scenario 'with steps', js: true do
      expected = build(:device_type, {
        steps: [
          build(:step, {
            apply_template: false,
            request_option: build(:request_option, {
              http_method: 'get',
              headers: [
                build(:header),
                build(:header)
              ]
            }),
            step_variables: [
              build(:step_variable, source_type: 'string'),
              build(:step_variable, source_type: 'header')
            ]
          }),
          build(:step, {
            apply_template: true,
            request_option: build(:request_option, {
              http_method: 'post',
              headers: [
                build(:header),
                build(:header)
              ]
            }),
            step_variables: [
              build(:step_variable, source_type: 'xpath'),
              build(:step_variable, source_type: 'string')
            ]
          })
        ]
      })

      create_device_type(expected)
      validate_device_type(expected, DeviceType.last)
    end

    scenario 'with multiple steps where apply_template = true', js: true do
      expected = build(:device_type,
        steps: [
          build(:step, apply_template: true, request_option: build(:request_option, http_method: 'get')),
          build(:step, apply_template: true, request_option: build(:request_option, http_method: 'get')),
        ]
      )

      create_device_type(expected)
      expect(page).to have_button('Create Device type')
      expect(page).to have_content('Device Type must have exactly one step with "Apply Template" enabled')
      expect(page).to have_content('Enable "Apply Template" for only one step', count: 2)
    end

    scenario 'with no steps where apply_template = true', js: true do
      expected = build(:device_type,
        steps: [
          build(:step, apply_template: false, request_option: build(:request_option, http_method: 'get')),
          build(:step, apply_template: false, request_option: build(:request_option, http_method: 'get')),
        ]
      )

      create_device_type(expected)
      expect(page).to have_button('Create Device type')
      expect(page).to have_content('Device Type must have exactly one step with "Apply Template" enabled')
    end
  end

  context 'download JSON export' do
    scenario 'contains the correct data' do
      device_types = [
        create(:device_type),
        create(:device_type)
      ]

      visit admin_device_types_path

      click_on('JSON')

      expect(page.response_headers['Content-Disposition']).to match(/^attachment/)
      expect(page.response_headers['Content-Disposition']).to match(/.json/)
      expect(page.response_headers['Content-Type']).to match(/^text\/json/)

      parsed_json = JSON.parse(page.body)

      expect(parsed_json).to include(*device_types.map do |device_type|
        {
          name: device_type.name,
          steps: device_type.steps.map do |step|
            {
              sort_order: step.sort_order,
              name: step.name,
              apply_template: step.apply_template,
              request_option: {
                url: step.request_option.url,
                http_method: step.request_option.http_method,
                body: step.request_option.body,
                basic_auth: step.request_option.basic_auth,
                headers: step.request_option.headers.map do |header|
                  {
                    name: header.name,
                    value: header.value
                  }
                end
              },
              step_variables: step.step_variables.map do |step_variable|
                {
                  sort_order: step_variable.sort_order,
                  name: step_variable.name,
                  source_type: step_variable.source_type,
                  value: step_variable.value
                }
              end
            }
          end
        }.deep_stringify_keys
      end)
    end
  end

  context 'displaying execution order of steps' do
    scenario 'with multiple steps added', js: true do
      visit new_admin_device_type_path

      3.times do |i|
        click_link('Step')
        within all('.steps > fieldset').last do
          fill_in 'Name', with: "Step #{i}"
        end
      end

      all('.steps > fieldset').each_with_index do |step, index|
        expect(step).to have_content("Step #{index + 1}")
      end
    end

    scenario 'with a step removed in the middle', js: true do
      visit new_admin_device_type_path

      3.times do |i|
        click_link('Step')
        within all('.steps > fieldset').last do
          fill_in 'Name', with: "Name #{i}"
        end
      end

      remove_link = all('.steps > fieldset')[1].find_link('Remove')
      execute_script('window.scroll(0, 0)')
      remove_link.click

      all('.steps > fieldset').each_with_index do |step, index|
        expect(step).to have_content("Step #{index + 1}")
      end
    end

    def drag_to(source, target)
      builder = page.driver.browser.action
      source = source.native
      target = target.native

      builder.click_and_hold source
      builder.move_to        target, 1, 11
      builder.release        source
      builder.perform
    end

    scenario 'with a step moved to a different location', js: true do
      device_type = create(:device_type, steps: Array.new(3) {|i| build(:step, name: "Name #{i}", sort_order: i, apply_template: i == 1) } )
      visit edit_admin_device_type_path(device_type)

      expect(page).to have_css('.steps > fieldset:nth-of-type(3) input[value="Name 2"]', visible: false)

      source_elem = page.all('.handle').first
      target = page.all('.handle').last
      execute_script('window.scroll(0, 0)')
      drag_to source_elem, target

      expect(page).to have_css('.steps > fieldset:nth-of-type(3) input[value="Name 0"]', visible: false)
      steps = all('.steps > fieldset')

      steps.each_with_index do |step, index|
        expect(step).to have_content("Step #{index + 1}")
      end
    end
  end

  def create_device_type(device_type)
    visit new_admin_device_type_path

    fill_in 'Name', with: device_type.name
    device_type.steps.each { |step| add_step(step) }

    click_button('Create Device type')
  end

  def add_step(step)
    click_link('Step')
    within all('.steps > fieldset').last do
      fill_in 'Name', with: step.name
      check 'Apply template' if step.apply_template
      uncheck 'Apply template' unless step.apply_template
      fill_in 'URL', with: step.request_option.url
      select step.request_option.http_method, from: 'HTTP method'
      fill_in 'Body', with: step.request_option.body
      check 'Basic auth' if step.request_option.basic_auth

      step.request_option.headers.each { |header| add_header(header) }
      step.step_variables.each { |variable| add_variable(variable) }
    end
  end

  def add_header(header)
    click_link('Header')
    within all(:css, 'li.headers > fieldset').last do
      fill_in 'Name', with: header.name
      fill_in 'Value', with: header.value
    end
  end

  def add_variable(variable)
    click_link('Variable')
    within all(:css, 'li.step_variables > fieldset').last do
      fill_in 'Name', with: variable.name
      select variable.source_type.humanize, from: 'Source'
      fill_in 'Value', with: variable.value
    end
  end

  def validate_device_type(expected, actual)
    expect(actual.name).to eq(expected.name)

    expect(actual.steps.count).to eq(expected.steps.length)
    expected.steps.each_with_index do |step, step_index|
      expect(actual.steps[step_index].name).to eq(step.name)
      expect(actual.steps[step_index].sort_order).to eq(step_index + 1)
      expect(actual.steps[step_index].apply_template).to eq(step.apply_template)

      expect(actual.steps[step_index].request_option.url).to eq(step.request_option.url)
      expect(actual.steps[step_index].request_option.http_method).to eq(step.request_option.http_method)
      expect(actual.steps[step_index].request_option.body).to eq(step.request_option.body)
      expect(actual.steps[step_index].request_option.basic_auth).to eq(step.request_option.basic_auth)

      expect(actual.steps[step_index].request_option.headers.count).to eq(step.request_option.headers.length)
      step.request_option.headers.each_with_index do |header, header_index|
        expect(actual.steps[step_index].request_option.headers[header_index].name).to eq(header.name)
        expect(actual.steps[step_index].request_option.headers[header_index].value).to eq(header.value)
      end

      expect(actual.steps[step_index].step_variables.count).to eq(step.step_variables.length)
      step.step_variables.each_with_index do |variable, variable_index|
        expect(actual.steps[step_index].step_variables[variable_index].name).to eq(variable.name)
        expect(actual.steps[step_index].step_variables[variable_index].sort_order).to eq(variable_index + 1)
        expect(actual.steps[step_index].step_variables[variable_index].source_type).to eq(variable.source_type)
        expect(actual.steps[step_index].step_variables[variable_index].value).to eq(variable.value)
      end
    end
  end
end
