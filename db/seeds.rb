require 'yaml'

data = {}
Dir.glob(File.join(Rails.root, 'db', 'seeds', '**', '*.yml')).each do |filename|
  new_data = YAML.load_file(filename)
  data.deep_merge!(new_data) do |_, old_value, new_value|
    if old_value.is_a?(Array) && new_value.is_a?(Array)
      old_value | new_value
    else
      new_value
    end
  end
end

data.deep_symbolize_keys!

admin_users = data[:admin_users] || []
device_types = data[:device_types] || []
templates = data[:templates] || []
devices = data[:devices] || []
service_accounts = data[:service_accounts] || []


def build_step_variable(variable_data, sort_order)
  variable_data[:sort_order] ||= sort_order
  StepVariable.new(variable_data)
end

def build_header(header_data)
  Header.new(header_data)
end

def build_request_option(request_option_data)
  RequestOption.new(
    url: request_option_data[:url] || '',
    http_method: request_option_data[:http_method],
    body: request_option_data[:body] || '',
    basic_auth: request_option_data[:basic_auth],
    headers: (request_option_data[:headers] || []).map { |header_data| build_header(header_data) }
  )
end

def build_step(step_data, sort_order)
  Step.new(
    name: step_data[:name],
    apply_template: step_data[:apply_template],
    sort_order: step_data[:sort_order] || sort_order,
    request_option: build_request_option(step_data[:request_option]),
    step_variables: (step_data[:step_variables] || []).each_with_index.map { |variable_data, i| build_step_variable(variable_data, i + 1) }
  )
end

puts '=== Admin Users ==='
admin_users.each do |admin_user|
  if AdminUser.search_by_email(admin_user[:email]).first
    puts "User #{admin_user[:email]} exists"
  else
    puts " ** Creating user #{admin_user[:email]}"
    AdminUser.create!(admin_user)
  end
end

puts '=== Device Types ==='
device_types.each do |device_type|
  if DeviceType.where(name: device_type[:name]).first
    puts "Device Type #{device_type[:name]} exists"
  else
    puts " ** Creating device type #{device_type[:name]}"
    DeviceType.where(name: device_type[:name]).create!(
      steps: device_type[:steps].each_with_index.map { |step_data, i| build_step(step_data, i + 1) }
    )
  end
end

puts '=== Templates ==='
templates.each do |template|
  device_type = DeviceType.where(name: template[:device_type]).first
  unless device_type
    puts " !! Device Type #{template[:device_type]} not found, skipping template #{template[:name]}"
    next
  end
  if Template.where(name: template[:name]).first
    puts "Template #{template[:name]} exists"
  else
    puts " ** Creating template #{template[:name]}"
    Template.where(name: template[:name]).create!(
      device_type: device_type,
      request_option: build_request_option(template[:request_option] || {}),
      transformation: template[:transformation],
      description: "WWT-delivered Template.\n\n#{template[:description]}"
    )
  end
end

puts '=== Devices ==='
devices.each do |device|
  device_type = DeviceType.where(name: device[:device_type]).first
  unless device_type
    puts " !! Device Type #{device[:device_type]} not found, skipping device #{device[:name]}"
    next
  end
  device[:device_type] = device_type

  if Device.where(name: device[:name]).first
    puts "Device #{device[:name]} exists"
  else
    puts " ** Creating device #{device[:name]}"
    Device.where(name: device[:name]).create!(device)
  end
end

puts '=== Arcus API Accounts ==='
service_accounts.each do |service_account|
  if ServiceAccount.where(name: service_account[:name]).first
    puts "Arcus API Account #{service_account[:name]} exists"
  else
    puts " ** Creating Arcus API Account #{service_account[:name]}"
    ServiceAccount.where(name: service_account[:name]).create!(service_account)
  end
end
