require 'reindeer'

describe Reindeer do
  it 'can be extended' do
    expect { Class.new { extend Reindeer } }.to_not raise_error
  end

  context 'when extended' do

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

    context 'with bad is' do
      let(:is)     { :jabbajabba }
      let(:params) { { is: is } }

      it 'throws an exception' do
        expect { example }.to raise_error(Reindeer::BadIs, "#{is} invalid")
      end
    end

    context 'with no is' do
      let(:params) { {} }

      it 'does not create a reader' do
        expect(example.new.methods).to_not include(getter)
      end

      it 'does not create a writer' do
        expect(example.new.methods).to_not include(setter)
      end
    end

    context 'when constructing an object' do

      let(:params)          { { is: :rw } }
      let(:expected_value)  { 42 }

      it 'accepts & records parameters to new' do
        instance = example.new( attribute_name => expected_value )
        expect(instance.instance_variable_get :"@#{getter}").to eq expected_value
      end
    end
  end
end
