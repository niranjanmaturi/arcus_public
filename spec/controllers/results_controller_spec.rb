require "rails_helper"

describe ResultsController do
  context "#index" do
    let(:pairs) do
      5.times.map { ["#{Faker::Lorem.word}-data", "#{Faker::Lorem.word}-label"] }
    end
    let(:client_results) { pairs.map { |pair_elem| { 'data' => pair_elem[0], 'label' => pair_elem[1] } } }
    let(:expected_results) { pairs.map { |pair_elem| { name: pair_elem[0], displayName: pair_elem[1] } }.to_json }

    let(:service_account) { create :service_account }
    let(:device_type) { create :device_type }
    let(:device) { create :device, device_type: device_type }
    let(:template) { create :template, device_type: device_type }
    let(:device_id) { device.id }
    let(:template_id) { template.id }
    let(:format) { 'c3' }
    let(:client_obj) { double 'api_client' }
    let(:param_name_1) { Faker::Lorem.words(2).join }
    let(:param_name_2) { Faker::Lorem.words(2).join }
    let(:param_value_1) { Faker::Lorem.words(2).join }
    let(:param_value_2) { Faker::Lorem.words(2).join }

    before do
      sign_in service_account
    end

    it 'makes calls to the appropriate service objects' do
      expect(MultiStepService).to receive(:new).with(device, template, {param_name_1 => param_value_1, param_value_2 => param_value_2}).and_return(client_obj)
      expect(client_obj).to receive(:results).and_return(client_results)

      get :index, {
        params: {
          device_id: device_id,
          template_id: template_id,
          format: format,
          param_name_1 => param_value_1,
          param_value_2 => param_value_2,
        }
      }

      expect(response.body).to eq(expected_results)
    end

    context 'when requesting a device and a template not of the same device type' do
      let(:device) { create :device, device_type: create(:device_type) }

      it 'returns a 200 with error message' do
        get :index, { params: { device_id: device_id, template_id: template_id, format: format } }

        expect(response.status).to eq(200)
      end
    end

    context 'can handle bad data' do
      let(:multi_step_service) { double 'multi step service' }

      before do
        allow(MultiStepService).to receive(:new).with(any_args).and_return multi_step_service
        allow(multi_step_service).to receive(:results).and_return results
      end

      context 'when all results are empty' do
        let(:results) { [] }

        it 'does not raise an error' do
          get :index, { params: { device_id: device_id, template_id: template_id, format: format } }

          expect(response.status).to eq(200)
          expect(response.body).to eq('[]')
        end
      end

      context 'when all name values are null' do
        let(:results) { [{'data' => nil, 'label' => nil}, {'data' => nil, 'label' => Faker::Lorem.word}] }

        it 'returns an error' do
          get :index, { params: { device_id: device_id, template_id: template_id, format: format } }

          expect(response.status).to eq(200)
          expect(response.body).to eq([{name: '', displayName: 'Error: All returned values are null'}].to_json)
        end
      end

      context 'when all displayName values are null' do
        let(:results) { [{'data' => Faker::Lorem.word, 'label' => nil}, {'data' => nil, 'label' => nil}] }

        it 'returns an error' do
          get :index, { params: { device_id: device_id, template_id: template_id, format: format } }

          expect(response.status).to eq(200)
          expect(response.body).to eq([{name: '', displayName: 'Error: All returned labels are null'}].to_json)
        end
      end
    end
  end
end
