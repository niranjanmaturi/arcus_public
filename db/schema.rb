# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170728151541) do

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "email",                  limit: 65535,              null: false
    t.string   "encrypted_password",                   default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role",                                              null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "device_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_device_types_on_name", unique: true, using: :btree
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "base_url",       limit: 65535, null: false
    t.string   "name",                         null: false
    t.integer  "device_type_id",               null: false
    t.boolean  "ssl_validation",               null: false
    t.text     "username",       limit: 65535
    t.text     "password",       limit: 65535
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["device_type_id"], name: "index_devices_on_device_type_id", using: :btree
    t.index ["name"], name: "index_devices_on_name", unique: true, using: :btree
  end

  create_table "headers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",              null: false
    t.string   "value",             null: false
    t.integer  "request_option_id", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["request_option_id"], name: "index_headers_on_request_option_id", using: :btree
  end

  create_table "request_options", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "url",                       null: false
    t.string   "http_method",               null: false
    t.text     "body",        limit: 65535, null: false
    t.boolean  "basic_auth"
    t.integer  "step_id"
    t.integer  "template_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["step_id"], name: "index_request_options_on_step_id", unique: true, using: :btree
    t.index ["template_id"], name: "index_request_options_on_template_id", unique: true, using: :btree
  end

  create_table "service_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "username",                         default: "", null: false
    t.string   "encrypted_password",               default: "", null: false
    t.string   "name",                             default: "", null: false
    t.text     "description",        limit: 65535
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["username"], name: "index_service_accounts_on_username", unique: true, using: :btree
  end

  create_table "step_variables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",        null: false
    t.integer  "sort_order",  null: false
    t.string   "source_type", null: false
    t.string   "value",       null: false
    t.integer  "step_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["step_id"], name: "index_step_variables_on_step_id", using: :btree
  end

  create_table "steps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",           null: false
    t.integer  "sort_order",     null: false
    t.boolean  "apply_template", null: false
    t.integer  "device_type_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["device_type_id"], name: "index_steps_on_device_type_id", using: :btree
  end

  create_table "templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                         null: false
    t.text     "transformation", limit: 65535, null: false
    t.text     "description",    limit: 65535
    t.integer  "device_type_id",               null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["device_type_id"], name: "index_templates_on_device_type_id", using: :btree
    t.index ["name"], name: "index_templates_on_name", unique: true, using: :btree
  end

  add_foreign_key "devices", "device_types"
  add_foreign_key "headers", "request_options"
  add_foreign_key "request_options", "steps"
  add_foreign_key "request_options", "templates"
  add_foreign_key "step_variables", "steps"
  add_foreign_key "steps", "device_types"
  add_foreign_key "templates", "device_types"
end
