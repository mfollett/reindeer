require 'reindeer'

describe Reindeer do
  it 'can be extended' do
    expect { Class.new { extend Reindeer } }.to_not raise_error
  end

  context 'when included' do

    let(:example) { Class.new { extend Reindeer } }

    it 'provides a has class method' do
      expect(example.methods).to include(:has)
    end
  end

  describe :has do

    let(:attribute_name) { :attribute_name }

    let(:getter) { :attribute_name }
    let(:setter) { :"#{:attribute_name}=" }

    let(:example) do
      example = Class.new { extend Reindeer }
      example.has attribute_name, params
      example
    end

    context 'with read-only accessors' do

      let(:params) { { is: :ro } }

      it 'creates a reader' do
        expect(example.new.methods).to include(getter)
      end

      it 'does not create a writer' do
        expect(example.new.methods).to_not include(setter)
      end
    end

    context 'with read/write accessors' do
      let(:params) { { is: :rw } }

      it 'creates a reader' do
        expect(example.new.methods).to include(getter)
      end

      it 'creates a writer' do
        expect(example.new.methods).to include(setter)
      end
    end
  end
end
