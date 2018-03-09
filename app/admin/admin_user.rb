ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :role
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  show do
    attributes_table do
      row :email
      row :role
      row :current_sign_in_at
      row :sign_in_count
      row :created_at
    end
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :email, as: :string
      f.input :password, placeholder: resource.persisted? && t('obscured_placeholder'), hint: t('password_help_html')
      f.input :password_confirmation, placeholder: resource.persisted? && t('obscured_placeholder'), input_html: {maxlength: 255}
      f.input :role, as: :select, collection: AdminUser::ROLES
    end
    f.actions
  end

  controller do
    def update
      if params[:admin_user][:password] == '' && params[:admin_user][:password_confirmation] == ''
        params[:admin_user].delete(:password)
        params[:admin_user].delete(:password_confirmation)
      end
      super
    end
  end
end
