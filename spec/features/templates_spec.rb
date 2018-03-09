require 'rails_helper'

RSpec.feature 'Template', type: :feature do
  let!(:admin) { create :admin_user, role: 'admin' }

  before do
    login_user(admin)
  end

  context 'download CSV export' do
    scenario 'contains the correct data' do
      device_type = create :device_type
      template = create :template, device_type: device_type

      visit admin_templates_path

      click_on('CSV')

      expect(page.response_headers['Content-Disposition']).to match(/^attachment/)
      expect(page.response_headers['Content-Disposition']).to match(/.csv/)
      expect(page.response_headers['Content-Type']).to match(/^text\/csv/)

      csv_contents_without_header = CSV.parse(page.body)[1..-1].flatten

      %w{name description url http_method transformation body}.each do |key|
        expect(csv_contents_without_header).to include(template.send(key.to_sym))
      end
    end
  end

  context 'download JSON export' do
    scenario 'contains the correct data' do
      device_type = create :device_type
      template = create :template, device_type: device_type

      visit admin_templates_path

      click_on('JSON')

      expect(page.response_headers['Content-Disposition']).to match(/^attachment/)
      expect(page.response_headers['Content-Disposition']).to match(/.json/)
      expect(page.response_headers['Content-Type']).to match(/^text\/json/)

      parsed_json = JSON.parse(page.body)

      tested_element = parsed_json.find{|pj| pj['name'] == template.name}

      expect(tested_element).not_to be_nil
      expect(tested_element['name']).to eq(template.name)
      expect(tested_element['description']).to eq(template.description)
      expect(tested_element['device_type']).to eq(template.device_type.name)
      expect(tested_element['transformation']).to eq(template.transformation)
      expect(tested_element['request_option']['url']).to eq(template.request_option.url)
      expect(tested_element['request_option']['http_method']).to eq(template.request_option.http_method)
      expect(tested_element['request_option']['body']).to eq(template.request_option.body)
      expect(tested_element['request_option']['headers']).to eq(template.request_option.headers.map{|header| { name: header.name, value: header.value}.stringify_keys})
    end
  end

  context 'show an existing template' do
    scenario 'with the appropriate data' do
      device_type = create :device_type
      template = create :template, device_type: device_type
      visit admin_template_path(template)

      expect(page).to have_text(template.name)
      expect(page).to have_text(template.description)
      expect(page).to have_text(template.request_option.url)
      expect(page).to have_text(template.request_option.http_method)
      expect(page).to have_text(device_type.name)
      expect(page).to have_text(template.body)
    end
  end

  context 'creating a template' do
    let(:http_method) { %w[get post].sample }
    let(:device_type) { create :device_type }
    let(:expected_template) do
      build(:template,
        device_type: device_type,
        request_option: build(:request_option,
          http_method: http_method,
          headers: headers
        )
      )
    end

    context 'with headers' do
      let(:headers) { [ build(:header), build(:header) ] }

      scenario 'creates template', js: true do
        create_template(expected_template)

        validate_template(Template.last, expected_template)
      end
    end

    context 'without headers' do
      let(:headers) { [] }

      scenario 'creates template', js: true do
        create_template(expected_template)

        validate_template(Template.last, expected_template)
      end
    end
  end

  def create_template(template)
    visit new_admin_template_path

    select device_type.name, from: 'Device type'
    fill_in 'Name', with: template.name
    fill_in 'Description', with: template.description
    fill_in 'URL', with: template.url
    select http_method, from: 'HTTP method'
    fill_in 'Transformation', with: template.transformation
    fill_in 'Body', with: template.body

    template.request_option.headers.each { |header| fill_in_header(header) }

    click_button('Create Template')
  end

  def fill_in_header(header)
    click_link('Header')
    within all('li.headers > fieldset').last do
      fill_in 'Name', with: header.name
      fill_in 'Value', with: header.value
    end
  end

  def validate_template(actual, expected)
    expect(actual.name).to eq(expected.name)
    expect(actual.description).to eq(expected.description)
    expect(actual.transformation.gsub("\r\n", "\n")).to eq(expected.transformation)
    expect(actual.request_option.http_method).to eq(expected.request_option.http_method)
    expect(actual.request_option.body).to eq(expected.request_option.body)
    expect(actual.request_option.url).to eq(expected.request_option.url)

    expect(actual.request_option.headers.count).to eq(expected.request_option.headers.length)

    actual.request_option.headers.each_with_index do |actual_header, index|
      expect(actual_header.name).to eq(expected.request_option.headers[index].name)
      expect(actual_header.value).to eq(expected.request_option.headers[index].value)
    end
  end
end
