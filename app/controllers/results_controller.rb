class ResultsController < ApplicationController
  before_action :ensure_same_device_types, only: :index
  before_action :authenticate_service_account!

  def index
    client = MultiStepService.new(device, template, request.query_parameters)
    results = client.results.map { |r| { name: r['data'], displayName: r['label'] } }

    handle_bad_data(results)

    render json: results.to_json, content_type: 'application/html'
  end

  private

  def handle_bad_data(results)
    return if results.empty?
    raise(ArcusErrors::NullValuesError, 'Error: All returned values are null') unless results.select{|r| !r[:name].nil?}.any?
    raise(ArcusErrors::NullLabelsError, 'Error: All returned labels are null') unless results.select{|r| !r[:displayName].nil?}.any?
  end

  def ensure_same_device_types
    raise ArcusErrors::DeviceTypeMismatch if device.device_type_id != template.device_type_id
  end

  def device
    @device ||= Device.find(params[:device_id])
  end

  def template
    @template ||= Template.find(params[:template_id])
  end
end
