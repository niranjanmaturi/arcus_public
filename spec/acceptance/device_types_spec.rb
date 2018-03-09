require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Device Types' do
  post '/admin/device_types/perform_import' do
    parameter :file, 'File containing JSON to upload', scope: :json_file
    parameter :json_file

    let(:path_to_file) { File.join(Rails.root, 'tmp', 'generated.json') }
    let(:path_to_bad_file) { File.join(Rails.root, 'tmp', 'bad.json') }
    let(:file) { Rack::Test::UploadedFile.new(path_to_file, 'application/json') }
    let(:obj_to_insert) { initial_obj_to_insert }
    let(:initial_obj_to_insert) do
      device_types.map do |device_type|
        {
          name: device_type.name,
          steps: device_type.steps.map do |step|
            {
              name: step.name,
              apply_template: step.apply_template,
              sort_order: step.sort_order,
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
                  name: step_variable.name,
                  sort_order: step_variable.sort_order,
                  source_type: step_variable.source_type,
                  value: step_variable.value
                }
              end
            }
          end
        }
      end
    end
    let(:initial_device_types) do
      5.times.map do |i|
        build(:device_type, steps: [
          build(:step, apply_template: false, sort_order: 1, step_variables: build_list(:step_variable, 2)),
          build(:step, apply_template: true, sort_order: 2, step_variables: build_list(:step_variable, 2))
        ])
      end
    end
    let(:device_types) { initial_device_types }
    before do
      login_to_admin
      File.open(path_to_file, 'w') do |f|
        f.write obj_to_insert.to_json
      end
      File.open(path_to_bad_file, 'w') {|f| f.write '' }
    end

    example 'it redirects to the index page' do
      do_request

      expect(status).to eq(302)
      expect(response_headers).to include('Location' => 'http://example.org/admin/device_types')
    end

    context 'when the file does not contain JSON' do
      let(:file) { Rack::Test::UploadedFile.new(path_to_bad_file, 'application/json') }
      example 'it redirects to the index page with a warning' do
        do_request

        expect(status).to eq(302)
        no_doc do
          client.get response_headers['Location']
          expect(response_body).to include('File does not contain valid JSON')
        end
      end
    end
    context 'when passed a file' do
      example 'it creates the device types from the file' do
        current_count = DeviceType.all.count
        do_request

        expect(status).to eq(302)
        expect(DeviceType.all.reload.count).to eq(current_count + 5)

        device_types.each do |device_type|
          db_device_type = DeviceType.where(name: device_type.name).first
          expect(db_device_type).not_to be_nil

          device_type.steps.each_with_index do |step, i|
            db_step = db_device_type.steps[i]

            expect(db_step.name).to eq(step.name)
            expect(db_step.sort_order).to eq(step.sort_order)
            expect(db_step.apply_template).to eq(step.apply_template)
            expect(db_step.request_option.url).to eq(step.request_option.url)
            expect(db_step.request_option.http_method).to eq(step.request_option.http_method)
            expect(db_step.request_option.body).to eq(step.request_option.body)
            expect(db_step.request_option.basic_auth).to eq(step.request_option.basic_auth)

            step.request_option.headers.each_with_index do |header, j|
              db_header = db_step.request_option.headers[j]

              expect(db_header.name).to eq(header.name)
              expect(db_header.value).to eq(header.value)
            end

            step.step_variables.order(:name).each_with_index do |step_variable, k|
              db_step_variable = db_step.step_variables.order(:name)[k]

              expect(db_step_variable.name).to eq(step_variable.name)
              expect(db_step_variable.sort_order).to eq(step_variable.sort_order)
              expect(db_step_variable.source_type).to eq(step_variable.source_type)
              expect(db_step_variable.value).to eq(step_variable.value)
            end
          end
        end
      end
      example 'it has no alert messages when successful' do
        do_request

        no_doc do
          client.get response_headers['Location']
          expect(response_body).to include('<div class="flashes"></div>')
        end
      end
    end
    context 'with multiple duplicate names' do
      let(:device_types) do
        changed_device_types = initial_device_types
        changed_device_types[4][:name] = changed_device_types[3][:name]
        changed_device_types[2][:name] = changed_device_types[1][:name]
        changed_device_types
      end
      example 'it rejects all the new device_types and displays the errors' do
        current_count = DeviceType.all.count
        do_request

        expect(status).to eq(302)
        expect(DeviceType.all.reload.count).to eq(current_count)

        no_doc do
          client.get response_headers['Location']
          expect(response_body).to include("DeviceType &#39;#{device_types[4][:name]}&#39; - Name is already in use")
          expect(response_body).to include("DeviceType &#39;#{device_types[2][:name]}&#39; - Name is already in use")
        end
      end
    end
  end
end
