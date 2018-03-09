ActiveAdmin.register Device do
  permit_params :device_type_id, :base_url, :username, :password, :name, :ssl_validation, :blank_password

  index do
    selectable_column
    id_column
    column :device_type
    column :name
    column 'Base URL / IP', &:base_url
    column :username
    column :password do |resource|
      status_tag !resource.password.blank?
    end
    column :ssl_validation
    column :created_at
    actions
  end

  filter :name
  filter :base_url
  filter :device_type
  filter :created_at

  show do
    attributes_table do
      row :device_type
      row :name
      row 'Base URL / IP', &:base_url
      row :username
      row :password do
        status_tag !resource.password.blank?
      end
      row :ssl_validation
      row :created_at
      row :updated_at
    end
    panel 'Templates' do
      table_for resource.device_type.templates.order(:name) do
        column :name do |template|
          link_to template.name, admin_template_path(template)
        end
        column :link do |template|
          query_string = ParsingService.list_parameter_names(template.request_option.url).map { |x| "#{x}=${value}" }.join('&')
          if (query_string.length > 0)
            query_string = '?' + query_string
          end
          copy_url = device_template_results_url(device_id: resource.id, template_id: template.id, format: 'c3', protocol: false).gsub(/^\/\//, '') + query_string
          input class: 'results_url', value: copy_url, readonly: true
        end
      end
    end
  end

  form do |f|
    f.inputs 'Device Details' do
      f.input :device_type, input_html: { disabled: !f.object.new_record? }
      f.input :name
      f.input :base_url, as: :string, label: 'Base URL / IP'
      f.input :ssl_validation, as: :aligned_boolean
      f.panel 'Device Account', class: 'form-group' do
        f.input :username, as: :string
        f.input :password, as: :password, input_html: { value: '', autocomplete: 'new-password', placeholder: resource.password.blank? ? nil : t('obscured_placeholder') }
        f.input :blank_password, as: :aligned_boolean if resource.persisted?
      end
    end
    f.actions
  end

  controller do
    def update
      if params[:device][:blank_password] == '1'
        params[:device][:password] = ''
      elsif params[:device][:password].blank?
        params[:device].delete(:password)
      end
      super
    end
  end
end
