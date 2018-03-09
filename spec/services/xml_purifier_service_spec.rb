require 'rails_helper'

describe XmlPurifierService do
  let(:value) { Faker::Lorem.word }

  let(:json_doc) { JSON.parse("{ \"#{bad_key}\": \"#{value}\" }") }

  context '#encoded_json_document when' do

    subject { described_class.new(json_doc).encoded_json_document }

    context 'key starts a digit' do
      let(:bad_key) { '1bad_key' }
      let(:good_key) { 'öoneöbad_key' }

      it 'works' do
        expect(subject[good_key]).to eq(value)
        expect(subject[bad_key]).to be_nil
      end
    end

    context 'key starts with space' do
      let(:bad_key) { ' bad_key' }
      let(:good_key) { 'öspaceöbad_key' }

      it 'works' do
        expect(subject[good_key]).to eq(value)
        expect(subject[bad_key]).to be_nil
      end
    end

    context 'key contains exclamation mark' do
      let(:bad_key) { 'bad!key' }
      let(:good_key) { 'badöexclamationMarkökey' }

      it 'works' do
        expect(subject[good_key]).to eq(value)
        expect(subject[bad_key]).to be_nil
      end
    end

    context 'a nested hash contains exclamation mark as part of a key' do
      let(:json_doc) { JSON.parse("{\"a\": \"b\", \"nested_hash\": { \"#{bad_key}\": \"#{value}\"} }") }
      let(:bad_key) { 'bad!key' }
      let(:good_key) { 'badöexclamationMarkökey' }

      it 'works' do
        expect(subject['nested_hash'][good_key]).to eq(value)
        expect(subject['nested_hash'][bad_key]).to be_nil
      end
    end

    context 'json is an array of json docs' do
      let(:json_doc) { JSON.parse("[{\"a\": \"b\"},{\"#{bad_key}\": \"#{value}\"}]") }
      let(:bad_key) { 'bad+key' }
      let(:good_key) { 'badöplusökey' }

      it 'works' do
        expect(subject[1][good_key]).to eq(value)
        expect(subject[1][bad_key]).to be_nil
      end
    end

    context 'full blown example' do
      let!(:json_doc) do
        JSON.parse <<-JSON
        [
          {
            "entityRef": {
              "id": "00000000a25e83f9:0000000000010083",
              " type": "DATASTORE",
              "name of thing": "DS01"
            },
            "stPlatDatastore": {
              "entityRef": {
                "!id:for+thing": "00000000a25e83f9:0000000000010083",
                "setConfignum": false
              },
              "config": {
                "name": "DS01"
              },
              "creationTime": 1507865921,
              "setFreeCapacity": true
            },
            "virtDatastore": {
              "entityRef": {
                "id": "datastore-35",
                "setConfignum": false
              },
              "url": "ds:///vmfs/volumes/c5dac790-427edc95/",
              "status": {
                "EntityRef(id:a45eecad-1502-6749-8a8b-95d0d0d12512, type:VIRTNODE, name:10.255.195.102)": {
                  "setMounted": true
                },
                "EntityRef(id:25499bb5-2071-4242-a92e-6a58c528bef2, type:VIRTNODE, name:10.255.195.105)": {
                  "setMounted": true
                }
              },
              "mountSummary": "MOUNTED",
              "setEntityRef": true
            }
          },
          {
            "entityRef": {
              "id": "00000000a25e83f9:0000000000287e2a",
              "type": "DATASTORE",
              "name": "DS03",
              "confignum": 0,
              "setId": true,
              "setName": true,
              "setType": true,
              "setIdtype": false,
              "setConfignum": false,
              "1234": "this should be converted because the key starts with a number"
            },
            "stPlatDatastore": {
              "entityRef": {
                "id": "00000000a25e83f9:0000000000287e2a",
                "type": "DATASTORE",
                "name": "DS03"
              },
              "config": {
                "name": "DS03",
                "setDataBlockSize": true
              }
            },
            "virtDatastore": {
              "entityRef": {
                "id": "datastore-30",
                "type": "VIRTDATASTORE",
                "name": "DS03"
              },
              "url": "ds:///vmfs/volumes/28a7006c-b164f4a2/",
              "status": {
                "EntityRef(id:fb609b29-08a6-3849-8cba-32e6dbb2e8c5, type:VIRTNODE, name:10.255.195.104)": {
                  "setAccessible": true
                }
              },
              "mountSummary": "MOUNTED"
            }
          }
        ]
        JSON
      end

      let!(:expected_safe_json) do
        JSON.parse <<-JSON2
        [
          {"entityRef":
            {"id": "00000000a25e83f9:0000000000010083",
             "öspaceötype": "DATASTORE",
             "nameöspaceöoföspaceöthing": "DS01"},
           "stPlatDatastore":
            {"entityRef":
              {"setConfignum": false,
               "öexclamationMarköidöcolonöforöplusöthing":
                "00000000a25e83f9:0000000000010083"},
             "config": {"name": "DS01"},
             "creationTime": 1507865921,
             "setFreeCapacity": true},
           "virtDatastore":
            {"entityRef": {"id": "datastore-35", "setConfignum": false},
             "url": "ds:///vmfs/volumes/c5dac790-427edc95/",
             "status":
              {"EntityReföleftParenthesisöidöcolonöa45eecad-1502-6749-8a8b-95d0d0d12512öcommaööspaceötypeöcolonöVIRTNODEöcommaööspaceönameöcolonö10.255.195.102örightParenthesisö":
                {"setMounted": true},
               "EntityReföleftParenthesisöidöcolonö25499bb5-2071-4242-a92e-6a58c528bef2öcommaööspaceötypeöcolonöVIRTNODEöcommaööspaceönameöcolonö10.255.195.105örightParenthesisö":
                {"setMounted": true}},
             "mountSummary": "MOUNTED",
             "setEntityRef": true}},
          {"entityRef":
            {"id": "00000000a25e83f9:0000000000287e2a",
             "type": "DATASTORE",
             "name": "DS03",
             "confignum": 0,
             "setId": true,
             "setName": true,
             "setType": true,
             "setIdtype": false,
             "setConfignum": false,
             "öoneö234": "this should be converted because the key starts with a number"
           },
           "stPlatDatastore":
            {"entityRef":
              {"id": "00000000a25e83f9:0000000000287e2a",
               "type": "DATASTORE",
               "name": "DS03"},
             "config": {"name": "DS03", "setDataBlockSize": true}},
           "virtDatastore":
            {"entityRef":
              {"id": "datastore-30", "type": "VIRTDATASTORE", "name": "DS03"},
             "url": "ds:///vmfs/volumes/28a7006c-b164f4a2/",
             "status":
              {"EntityReföleftParenthesisöidöcolonöfb609b29-08a6-3849-8cba-32e6dbb2e8c5öcommaööspaceötypeöcolonöVIRTNODEöcommaööspaceönameöcolonö10.255.195.104örightParenthesisö":
                {"setAccessible": true}},
             "mountSummary": "MOUNTED"}
           }
         ]
        JSON2
      end

      it 'converts the JSON in the right way' do
        expect(subject).to eq(expected_safe_json)
      end
    end
  end

end
