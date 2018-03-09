ActiveAdmin.register ServiceAccount do
  permit_params :name, :description, :username, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    column :username
    column :created_at
    actions
  end

  filter :name
  filter :username
  filter :created_at

  show do
    attributes_table do
      row :name
      row :description
      row :username
    end
  end

  form do |f|
    f.inputs 'Arcus API Account Details' do
      f.input :name, as: :string, label: 'Descriptive Name'
      f.input :description, as: :string
      f.panel 'Credentials', class: 'form-group' do
        f.input :username, as: :string
        f.input :password, placeholder: resource.persisted? && t('obscured_placeholder'), hint: t('password_help_html')
        f.input :password_confirmation, placeholder: resource.persisted? && t('obscured_placeholder')
      end
    end
    f.actions
  end

  controller do
    def update
      if params[:service_account][:password] == '' && params[:service_account][:password_confirmation] == ''
        params[:service_account].delete(:password)
        params[:service_account].delete(:password_confirmation)
      end
      super
    end
  end
end
