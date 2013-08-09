require 'reindeer'

describe Reindeer do

  let(:example) { Class.new { extend Reindeer } }
  it 'can be extended' do
    expect { example }.to_not raise_error
  end

  context 'when extended' do
    it 'provides a has class method' do
      expect(example.methods).to include(:has)
    end
  end

  describe ':has' do

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

    context 'when constructing an object' do

      let(:params)          { { is: :rw } }
      let(:expected_value)  { 42 }

      it 'accepts & records parameters to new' do
        instance = example.new( attribute_name => expected_value )
        expect(instance.instance_variable_get :"@#{getter}").to eq expected_value
      end
    end

    context 'when generating a predicate' do

      let(:params)    { { is: :ro, predicate: true } }
      let(:predicate) { :"#{attribute_name}?" }

      it 'evaluates true when the value is set' do
        expect(example.new( attribute_name => 42 ).send predicate).to be_true
      end

      it 'evaluates true when the value is set' do
        expect(example.new.send predicate).to be_false
      end
    end

    context 'when not generating a predicate' do
      let(:params)    { { is: :ro } }
      let(:predicate) { :"#{attribute_name}?" }

      it 'does not have a predicate' do
        expect(example.methods).to_not include(predicate)
      end
    end

    context 'when generating a clearer' do
      let(:params)    { { is: :ro, clearer: true } }
      let(:clearer)   { :"clear_#{attribute_name}!" }
      let(:old_value) { 42 }
      let(:instance)  { example.new( attribute_name => old_value ) }

      it 'generates a method to clear an attribute' do
        expect {instance.send clearer}.
          to change { instance.instance_variable_get :"@#{attribute_name}" } .
          from(old_value).to(nil)
      end
    end

    context 'when not generating a clearer' do
      let(:params)  { { is: :ro } }
      let(:clearer) { :"clear_#{attribute_name}!" }
      let(:instance)  { example.new }

      it 'does not have a predicate' do
        expect(instance.methods).to_not include(clearer)
      end
    end

    context 'when an attribute is required for initialization' do
      let(:params) { { is: :ro, required: true } }
      let(:value)  { 99 }

      it 'raises an exception when it is missing' do
        expect { example.new }.to raise_error Reindeer::MissingParameter
      end

      it 'assigns the required value' do
        instance = example.new attribute_name => value
        expect(instance.send getter).to eq value
      end
    end

    context 'when handling defaults' do

      context 'if no default is provided' do
        let(:params) { { is: :rw } }

        it 'does not have a default' do
          instance = example.new
          expect(instance.send attribute_name).to be_nil
        end

        it 'does not change the actual value' do
          instance = example.new attribute_name: 11
          expect(instance.send attribute_name).to eq 11
        end
      end

      context 'if a default is provided' do
        let(:default) { 99 }
        let(:params)  { { is: :rw, default: default } }

        it 'does uses the default when there is no value' do
          instance = example.new
          expect(instance.send attribute_name).to eq default
        end

        it 'does not change the actual value' do
          instance = example.new attribute_name: 62
          expect(instance.send attribute_name).to eq 62
        end
      end

      describe :builder do

        let(:example_class) do
          Class.new do
            extend Reindeer
            has :foo, builder: :build_foo
            def build_foo; 42 end
          end
        end

        it 'uses the provided builder to build an attribute' do
          expect(example_class.new.foo).to eq 42
        end

        it 'does not override an initialization value' do
          expect(example_class.new(foo: 99).foo).to eq 99
        end
      end
    end
  end
end
