ActiveAdmin.register DeviceType do
  permit_params(
    :name,
    steps_attributes: [
      :id,
      :name,
      :sort_order,
      :apply_template,
      :_destroy,
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
      step_variables_attributes: [
        :id,
        :name,
        :sort_order,
        :source_type,
        :value,
        :_destroy,
      ],
    ]
  )

  batch_action :destroy, false

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  filter :name

  batch_action :export_as_json do |ids|
    redirect_to admin_device_types_url(q: { id_in: ids }, format: :json)
  end

  action_item :export_as_json, only: :show do
    link_to 'Export as JSON', admin_device_types_url(q: { id_in: [device_type.id] }, format: :json)
  end

  batch_action :export_as_csv do |ids|
    redirect_to admin_device_types_url(q: { id_in: ids }, format: :csv)
  end

  action_item :export_as_csv, only: :show do
    link_to 'Export as CSV', admin_device_types_url(q: { id_in: [device_type.id] }, format: :csv)
  end

  action_item :import, only: :index do
    link_to 'Import from JSON', import_admin_device_types_url
  end

  collection_action :import do; end

  collection_action :perform_import, method: :post do
    begin
      file_contents = params[:json_file][:file].read
      inputs = JSON.parse(file_contents)
      alerts = []
      DeviceType.transaction do
        inputs.each do |input|
          device_type = DeviceType.new(name: input['name'])
          input['steps'].each do |step|
            new_headers = step['request_option']['headers'].map {|header| Header.new(header) }
            new_request_option = RequestOption.new(step['request_option'].merge(headers: new_headers))
            new_step_variables = step['step_variables'].map{|step_variable| StepVariable.new(step_variable)}
            new_step = Step.new(step.merge(request_option: new_request_option, step_variables: new_step_variables))
            device_type.steps << new_step
          end
          device_type.save
          next if device_type.valid?

          device_type.errors.full_messages.each do |msg|
            alerts << "DeviceType '#{input['name']}' - #{msg}"
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

    redirect_to admin_device_types_url
  end

  show do
    attributes_table do
      row :name
      row :created_at
      row :updated_at
    end
    panel 'Steps' do
      table_for resource.steps do
        column :sort_order
        column :name
        column :apply_template
        column(:url) { |step| step.request_option.url }
        column(:http_method) { |step| step.request_option.http_method }
        column(:body) { |step| step.request_option.body }
        column(:basic_auth) { |step| step.request_option.basic_auth }
        column 'Headers' do |step|
          table_for step.request_option.headers do
            column :name
            column :value
          end
        end
        column 'Variables' do |step|
          table_for step.step_variables do
            column :sort_order
            column :name
            column :source_type
            column :value
          end
        end
      end
    end
    panel 'Templates' do
      table_for resource.templates do
        column :id do |template|
          link_to template.id, admin_template_path(template)
        end
        column :name
        column :device_type
        column :updated_at
      end
    end
    panel 'Devices' do
      table_for resource.devices do
        column :id do |device|
          link_to device.id, admin_device_path(device)
        end
        column :name
        column :base_url
        column :device_type
        column :updated_at
      end
    end
  end

  form do |f|
    f.semantic_errors :base
    f.inputs 'Device Type Details' do
      f.input :name
    end
    f.has_many :steps,
               heading: 'Steps',
               sortable: :sort_order,
               sortable_start: 1,
               class: 'child-model ui-accordion',
               allow_destroy: true do |step|
      step.template.concat "<h3 class='accordion-toggle'><span class='step-order'>Step <span data-source='sort_order'></span></span> <span data-source='name' class='step-name'></span></h3>".html_safe
      step.template.concat '<div class="accordion-wrapper">'.html_safe

      step.input :name
      step.input :apply_template, as: :aligned_boolean
      step.has_many :request_option, heading: false, new_record: false do |x|
        x.input :url, as: :string, hint: t(:susbstition_help)
        x.input :http_method, as: :select, collection: %w[get post], include_blank: false
        x.input :body, hint: t(:susbstition_help)
        x.input :basic_auth, as: :aligned_boolean
        x.has_many :headers,
                    heading: 'Populate Request Headers',
                    new_record: 'Add Header',
                    class: 'child-model',
                    allow_destroy: true do |header|
          header.input :name, hint: t(:susbstition_help)
          header.input :value, hint: t(:susbstition_help)
        end
      end
      step.has_many :step_variables,
                      sortable: :sort_order,
                      sortable_start: 1,
                      heading: 'Set Variables',
                      new_record: 'Add Variable',
                      class: 'child-model ui-accordion',
                      allow_destroy: true do |variable|
        variable.template.concat "<h3 class='accordion-toggle'><span class='step-order'>Variable <span data-source='sort_order'></span></span> <span data-source='name' class='step-name'></span></h3>".html_safe
        variable.template.concat '<div class="accordion-wrapper">'.html_safe
        variable.input :name, hint: t(:susbstition_help)
        variable.input :source_type, :as => :select, :collection => {
          "String - manually enter a value": "string",
          "Header - retrieve value from the specified HTTP response header": "header",
          "XPath - parse value from an XML response body using the specified XPath expression": "xpath",
          "JSONPath - parse value from a JSON response body using the specified JSONPath expression": "jsonpath"
        }
        variable.input :value, hint: t(:susbstition_help)
        variable.template.concat '</div>'.html_safe
      end
      step.template.concat '</div>'.html_safe
    end
    f.actions
  end

  controller do
    def index
      super do |format|
        format.json do
          payload = @device_types.map do |device_type|
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
            }
          end

          send_data payload.to_json,
            type: 'text/json; charset=iso-8859-1; header=present',
            disposition: "attachment; filename=device_types_#{Time.now.iso8601}.json"
        end

        yield(format) if block_given?
      end
    end
  end
end
