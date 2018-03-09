require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Templates' do
  post '/admin/templates/perform_import' do
    parameter :file, 'File containing JSON to upload', scope: :json_file
    parameter :json_file

    let(:path_to_file) { File.join(Rails.root, 'tmp', 'generated.json') }
    let(:path_to_bad_file) { File.join(Rails.root, 'tmp', 'bad.json') }
    let(:file) { Rack::Test::UploadedFile.new(path_to_file, 'application/json') }
    let(:obj_to_insert) { initial_obj_to_insert }
    let(:initial_obj_to_insert) do
      templates.map do |template|
        {
          name: template.name,
          description: template.description,
          transformation: template.transformation,
          device_type: template.device_type.name,
          request_option: {
            url: template.request_option.url,
            http_method: template.request_option.http_method,
            body: template.request_option.body,
            headers: template.request_option.headers.map do |header|
              {
                name: header.name,
                value: header.value,
              }
            end
          }
        }
      end
    end
    let(:device_types) { 5.times.map {|i| create(:device_type, name: "#{Faker::Lorem.word}-#{i}") } }
    let(:initial_templates) { 5.times.map {|i| build(:template, name: "#{Faker::Lorem.word}-#{i}", device_type: device_types[i]) } }
    let(:templates) { initial_templates }
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
      expect(response_headers).to include('Location' => "http://example.org/admin/templates")
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
      example 'it creates the templates from the file' do
        current_count = Template.all.count
        do_request

        expect(status).to eq(302)
        expect(Template.all.reload.count).to eq(current_count + 5)

        templates.each do |template|

          db_template = Template.where(name: template.name).first
          expect(db_template).not_to be_nil
          expect(db_template.device_type.name).to eq(template.device_type.name)
          expect(db_template.description).to eq(template.description)
          expect(db_template.transformation).to eq(template.transformation)
          expect(db_template.request_option.url).to eq(template.request_option.url)
          expect(db_template.request_option.http_method).to eq(template.request_option.http_method)
          expect(db_template.request_option.body).to eq(template.request_option.body)
          expect(db_template.request_option.headers.length).to eq(template.request_option.headers.length)

          sorted_headers = template.request_option.headers.sort_by(&:name)
          db_template.request_option.headers.order(:name).each_with_index do |db_header, i|
            expect(db_header.name).to eq(sorted_headers[i].name)
            expect(db_header.value).to eq(sorted_headers[i].value)
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

      context 'with multiple duplicate names' do
        let(:templates) do
          changed_templates = initial_templates
          changed_templates[4][:name] = changed_templates[3][:name]
          changed_templates[2][:name] = changed_templates[1][:name]
          changed_templates
        end
        example 'it rejects all the new templates and displays the errors' do
          current_count = Template.all.count
          do_request

          expect(status).to eq(302)
          expect(Template.all.reload.count).to eq(current_count)

          no_doc do
            client.get response_headers['Location']
            expect(response_body).to include("Template &#39;#{templates[4][:name]}&#39; - Name is already in use")
            expect(response_body).to include("Template &#39;#{templates[2][:name]}&#39; - Name is already in use")
          end
        end
      end
      context 'with an invalid device type' do
        let(:obj_to_insert) do
          changed_obj = initial_obj_to_insert
          changed_obj[4][:device_type] = 'Wonderful foo bar device type'
          changed_obj
        end
        example 'it rejects all the new templates and displays the errors' do
          current_count = Template.all.count
          do_request

          expect(status).to eq(302)
          expect(Template.all.reload.count).to eq(current_count)

          no_doc do
            client.get response_headers['Location']
            expect(response_body).to include("Template &#39;#{templates[4][:name]}&#39; - Invalid Device Type")
          end
        end
      end
      context 'with an invalid device type and a duplicate name' do
        let(:obj_to_insert) do
          changed_obj = initial_obj_to_insert
          changed_obj[4][:device_type] = 'Wonderful foo bar device type'
          changed_obj[4][:name] = changed_obj[3][:name]
          changed_obj
        end
        example 'it rejects all the new templates and displays the errors' do
          current_count = Template.all.count
          do_request

          expect(status).to eq(302)
          expect(Template.all.reload.count).to eq(current_count)

          no_doc do
            client.get response_headers['Location']
            expect(response_body).to include("Template &#39;#{obj_to_insert[4][:name]}&#39; - Invalid Device Type")
            expect(response_body).to include("Template &#39;#{obj_to_insert[4][:name]}&#39; - Name is already in use")
          end
        end
      end
    end
  end
end
