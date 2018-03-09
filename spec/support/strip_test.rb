RSpec.shared_examples 'trims the field' do |column_name|
  context "strips the '#{column_name}'" do
    let(:value) { Faker::Lorem.sentence }
    before do
      subject.send("#{column_name}=", "  #{value}  ")
      subject.valid?
    end

    it 'trims the whitespace on both sides of the field' do
      expect(subject.send(column_name)).to eq(value)
    end
  end
  context "when fed nil for '#{column_name}'" do
    it 'does not explode when given no value' do
      subject.send("#{column_name}=", nil)
      expect { subject.valid? }.not_to raise_error
    end
  end
end
