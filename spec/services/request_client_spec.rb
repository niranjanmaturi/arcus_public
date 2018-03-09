require 'rails_helper'

describe RequestClient do
  context('#request') do

    subject { RequestClient }

    let(:url) { double('url') }
    let(:options) { double('options') }
    let(:response) { double('response') }

    it 'can post' do
      expect(subject).to receive(:post).with(url, options).and_return(response)

      result = subject.request('post', url, options)

      expect(result).to eq(response)
    end

    it 'can get' do
      expect(subject).to receive(:get).with(url, options).and_return(response)

      result = subject.request('get', url, options)

      expect(result).to eq(response)
    end
  end
end
