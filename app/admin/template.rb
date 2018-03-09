ActiveAdmin.register Template do
  permit_params(
    :device_type_id,
    :name,
    :transformation,
    :description,
    request_option_attributes: [
      :id,
      :url,
      :http_method,
      :body,
      :basic_auth,
      headers_attributes: [
        :id,
        :name,
        :value,
        :_destroy,
      ],
    ],
  )

  index do
    selectable_column
    id_column
    column :name
    column :description
    column(:url) { |resource| resource.request_option.url }
    column(:http_method) { |resource| resource.request_option.http_method }
    column :device_type
    column :created_at
    actions
  end

  filter :name
  filter :description
  filter(:url) { |resource| resource.request_option.url }
  filter(:http_method) { |resource| resource.request_option.http_method }
  filter :device_type
  filter :created_at

  csv do
    column :name
    column :description
    column(:url) { |resource| resource.request_option.url }
    column(:http_method) { |resource| resource.request_option.http_method }
    column(:body) { |resource| resource.request_option.body }
    column :transformation
    column(:device_type) { |resource| resource.device_type.name }
  end

  show do
    attributes_table do
      row :name
      row :description
      row(:url) { |resource| resource.request_option.url }
      row(:http_method) { |resource| resource.request_option.http_method }
      row :device_type
      row :body do
        pre do
          resource.request_option.body
        end
      end
      row :transformation do
        pre do
          resource.transformation
        end
      end
      row :created_at
      row :updated_at
    end
  end

  batch_action :export_as_json do |ids|
    redirect_to admin_templates_url(q: { id_in: ids }, format: :json)
  end

  action_item :export_as_json, only: :show do
    link_to 'Export as JSON', admin_templates_url(q: { id_in: [template.id] }, format: :json)
  end

  batch_action :export_as_csv do |ids|
    redirect_to admin_templates_url(q: { id_in: ids }, format: :csv)
  end

  action_item :export_as_csv, only: :show do
    link_to 'Export as CSV', admin_templates_url(q: { id_in: [template.id] }, format: :csv)
  end

  collection_action :import do; end

  collection_action :perform_import, method: :post do
    begin
      file_contents = params[:json_file][:file].read
      inputs = JSON.parse(file_contents)
      alerts = []

      Template.transaction do
        inputs.each do |input|
          device_type = DeviceType.where(name: input['device_type']).first
          if device_type.nil?
            alerts << "Template '#{input['name']}' - Invalid Device Type"
          end
          headers = input['request_option']['headers'].map { |header| Header.new(header) }
          template = Template.create(input.merge(device_type: device_type, request_option: RequestOption.new(input['request_option'].merge(headers: headers))))
          next if template.valid?
          template.errors.full_messages.each do |msg|
            alerts << "Template '#{input['name']}' - #{msg}"
          end
        end
        if alerts.any?
          flash[:alert] = alerts
          raise ActiveRecord::Rollback
        end
      end
    rescue JSON::ParserError
      flash[:error] = 'File does not contain valid JSON'
    end
    redirect_to admin_templates_url
  end

  action_item :import, only: :index do
    link_to 'Import from JSON', import_admin_templates_url
  end

  form do |f|
    f.inputs 'Template Details' do
      f.input :device_type, input_html: { disabled: !f.object.new_record? }
      f.input :name
      f.input :description
      f.has_many :request_option, heading: false, new_record: false do |x|
        x.input :url, as: :string, hint: t(:susbstition_help)
        x.input :http_method, :as => :select, :collection => ["get", "post"]
        x.input :body, hint: t(:susbstition_help)
        x.has_many :headers,
                    heading: 'Populate Request Headers',
                    new_record: 'Add Header',
                    class: 'child-model',
                    allow_destroy: true do |header|
          header.input :name, hint: t(:susbstition_help)
          header.input :value, hint: t(:susbstition_help)
        end
      end
      f.input :transformation
    end
    f.actions
  end

  controller do
    def current_user
      # load_and_authorize_resource
      current_admin_user
    end

    def index
      super do |format|
        format.json do
          payload = @templates.map do |template|
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

          send_data payload.to_json,
            type: 'text/json; charset=iso-8859-1; header=present',
            disposition: "attachment; filename=templates_#{Time.now.iso8601}.json"
        end

        yield(format) if block_given?
      end
    end
  end
end
