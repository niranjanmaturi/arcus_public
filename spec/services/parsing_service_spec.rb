require "rails_helper"

describe ParsingService do
  context 'param_regex' do
    it 'returns the correct regex' do
      expect(described_class.param_regex).to eq(/\$\{(\w+)\}/)
    end
  end

  context '#parse_url' do
    subject { described_class }

    examples = [
      {
        name: 'substitutes multiple parameters',
        input: 'test/q${first}q/${second}.${first}',
        expected: 'test/qappleq/banana.apple',
        parameters: {
          'first' => 'apple',
          'second' => 'banana'
        }
      },
      {
        name: 'input encodes special characters in parameters',
        input: '${a}',
        expected: '%21%2A%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%23%5B%5D%20%22%25%3C%3E%5C%5E%60%7B%7C%7D%7E',
        parameters: {
          'a' => '!*\'();:@&=+$,/?#[] "%<>\^`{|}~'
        }
      },
      {
        name: 'input encodes new lines in parameters',
        input: '${a}',
        expected: '%0A',
        parameters: {
          'a' => "\n"
        }
      },
      {
        name: 'does not encode special characters outside parameters',
        input: '${test_item}{thing}$%',
        expected: 'fopo{thing}$%',
        parameters: {
          'test_item' => 'fopo'
        }
      },
      {
        name: 'does not replace, nor errors, with invalid special characters',
        input: '${other-item}',
        expected: '${other-item}',
        parameters: {}
      },
      {
        name: 'accepts query parameters with underscores and numbers',
        input: '${test_item}-${item12}',
        expected: 'fopo-bar',
        parameters: {
          'test_item' => 'fopo',
          'item12' => 'bar'
        }
      },
      {
        name: 'raises error when parameter is missing',
        input: '${b}',
        expected_error: ArcusErrors::InvalidParameter,
        parameters: {
          'a' => 'a'
        }
      }
    ]

    examples.each do |example|
      it example[:name] do
        if example[:expected_error]
          expect { subject.parse_url(example[:input], example[:parameters]) }.to raise_error(example[:expected_error])
        else
          actual = subject.parse_url(example[:input], example[:parameters])
          expect(actual).to eq(example[:expected])
        end
      end
    end
  end

  context '#parse' do
    subject { described_class }

    examples = [
      {
        name: 'substitutes multiple parameters',
        input: 'test/q${first}q/${second}.${first}',
        expected: 'test/qappleq/banana.apple',
        parameters: {
          'first' => 'apple',
          'second' => 'banana'
        }
      },
      {
        name: 'does not encode special characters in parameters',
        input: '${a}',
        expected: '!*\'();:@&=+$,/?#[] "%<>\^`{|}~',
        parameters: {
          'a' => '!*\'();:@&=+$,/?#[] "%<>\^`{|}~'
        }
      },
      {
        name: 'does not encode special characters outside parameters',
        input: '${test_item}{thing}$%',
        expected: 'fopo{thing}$%',
        parameters: {
          'test_item' => 'fopo'
        }
      },
      {
        name: 'does not replace, nor errors, with invalid special characters',
        input: '${other-item}',
        expected: '${other-item}',
        parameters: {}
      },
      {
        name: 'accepts query parameters with underscores and numbers',
        input: '${test_item}-${item12}',
        expected: 'fopo-bar',
        parameters: {
          'test_item' => 'fopo',
          'item12' => 'bar'
        }
      },
      {
        name: 'raises error when parameter is missing',
        input: '${b}',
        expected_error: ArcusErrors::InvalidParameter,
        parameters: {
          'a' => 'a'
        }
      },
      {
        name: 'raises error when function is unsupported',
        input: '${test(a)}',
        expected_error: ArcusErrors::InvalidFunction,
        parameters: {
          'a' => 'a'
        }
      },
      {
        name: 'supports url encoding',
        input: '${url(a)}',
        expected: '%21%2A%27%28%29%3B%3A%40%26%3D%2B%24%2C%2F%3F%23%5B%5D%20%22%25%3C%3E%5C%5E%60%7B%7C%7D%7E',
        parameters: {
          'a' => '!*\'();:@&=+$,/?#[] "%<>\^`{|}~'
        }
      },
      {
        name: 'supports json encoding',
        input: '${json(a)}',
        expected: '\"hello\\\\goodbye\"',
        parameters: {
          'a' => '"hello\goodbye"'
        }
      },
      {
        name: 'supports xml encoding',
        input: '${xml(a)}',
        expected: 'this is &quot;my&quot; complicated &lt;String&gt; &amp; stuff',
        parameters: {
          'a' => 'this is "my" complicated <String> & stuff'
        }
      }
    ]

    examples.each do |example|
      it example[:name] do
        if example[:expected_error]
          expect { subject.parse(example[:input], example[:parameters]) }.to raise_error(example[:expected_error])
        else
          actual = subject.parse(example[:input], example[:parameters])
          expect(actual).to eq(example[:expected])
        end
      end
    end
  end

  context '#list_parameter_names' do
    subject { described_class }

    it 'returns empty array when there are no parameters' do
      input = Faker::Internet.url
      expected = []

      actual = subject.list_parameter_names(input)

      expect(actual).to eq(expected)
    end

    it 'returns a parameter name when provided one' do
      name = Faker::Lorem.word
      input = "${#{name}}"
      expected = [name]

      actual = subject.list_parameter_names(input)

      expect(actual).to eq(expected)
    end

    it 'returns a parameter name in a function' do
      function = Faker::Lorem.word
      name = Faker::Lorem.word
      input = "${#{function}(#{name})}"
      expected = [name]

      actual = subject.list_parameter_names(input)

      expect(actual).to eq(expected)
    end

    it 'does not return duplicate names' do
      name = Faker::Lorem.word
      input = "${#{name}}${#{name}}"
      expected = [name]

      actual = subject.list_parameter_names(input)

      expect(actual).to eq(expected)
    end

    it 'does not match braces without a dollar' do
      input = '{test}'
      expected = []

      actual = subject.list_parameter_names(input)

      expect(actual).to eq(expected)
    end

    it 'correctly matches a complex string' do
      input = 'a${x}${z}b${y}${z}c'
      expected = %w[x z y]

      actual = subject.list_parameter_names(input)

      expect(actual).to eq(expected)
    end
  end
end
