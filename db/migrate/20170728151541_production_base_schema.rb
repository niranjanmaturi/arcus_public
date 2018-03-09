class ProductionBaseSchema < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_users do |t|
      ## Database authenticatable
      t.text   :email,              null: false
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, null: false, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Custom fields
      t.string   :role, null: false

      t.timestamps null: false

      ## Indexes
      t.index [:reset_password_token], unique: true
    end

    create_table :device_types do |t|
      t.string :name, null: false

      t.timestamps null: false

      ## Indexes
      t.index [:name], unique: true
    end

    create_table :devices do |t|
      t.text     :base_url,       null: false
      t.string   :name,           null: false
      t.integer  :device_type_id, null: false
      t.boolean  :ssl_validation, null: false
      t.text     :username
      t.text     :password

      t.timestamps null: false

      ## Indexes
      t.index [:device_type_id]
      t.index [:name], unique: true
    end

    create_table :headers do |t|
      t.string   :name,              null: false
      t.string   :value,             null: false
      t.integer  :request_option_id, null: false

      t.timestamps null: false

      ## Indexes
      t.index [:request_option_id]
    end

    create_table :request_options do |t|
      t.string   :url,         null: false
      t.string   :http_method, null: false
      t.text     :body,        null: false
      t.boolean  :basic_auth
      t.integer  :step_id
      t.integer  :template_id

      t.timestamps null: false

      ## Indexes
      t.index [:step_id], unique: true
      t.index [:template_id], unique: true
    end

    create_table :service_accounts do |t|
      ## Database authenticatable
      t.string :username,           null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Custom fields
      t.string   :name,        null: false, default: ''
      t.text     :description

      t.timestamps null: false

      ## Indexes
      t.index [:username], unique: true
    end

    create_table :step_variables do |t|
      t.string   :name,        null: false
      t.integer  :sort_order,  null: false
      t.string   :source_type, null: false
      t.string   :value,       null: false
      t.integer  :step_id,     null: false

      t.timestamps null: false

      ## Indexes
      t.index [:step_id]
    end

    create_table :steps do |t|
      t.string   :name,           null: false
      t.integer  :sort_order,     null: false
      t.boolean  :apply_template, null: false
      t.integer  :device_type_id, null: false

      t.timestamps null: false

      ## Indexes
      t.index [:device_type_id]
    end

    create_table :templates do |t|
      t.string   :name,           null: false
      t.text     :transformation, null: false
      t.text     :description
      t.integer  :device_type_id, null: false

      t.timestamps null: false

      ## Indexes
      t.index [:device_type_id]
      t.index [:name], unique: true
    end

    add_foreign_key :devices,         :device_types
    add_foreign_key :headers,         :request_options
    add_foreign_key :request_options, :steps
    add_foreign_key :request_options, :templates
    add_foreign_key :step_variables,  :steps
    add_foreign_key :steps,           :device_types
    add_foreign_key :templates,       :device_types
  end
end
