require 'spec_helper'

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

  describe :has do

    include_context 'common names'

    context 'with read-only accessors' do

      include_context 'an attribute with access', :ro

      it { has_a getter }

      it { has_no setter    }
      it { has_no predicate }
      it { has_no clearer   }

      it { does_not_define_the_ivar }

    end

    context 'with read/write accessors' do

      include_context 'an attribute with access', :rw

      it {has_a getter }
      it {has_a setter }

      it { has_no predicate }
      it { has_no clearer   }

      it { does_not_define_the_ivar }

    end

    context 'with bad is' do

      include_context 'an attribute with access', :jabba

      it 'throws an exception' do
        expect { instance }.to raise_error(Reindeer::BadIs, "jabba invalid")
      end
    end

    context 'when constructing an object' do

      include_context 'an attribute with access', :ro

      let(:expected_value)           { 42 }
      let(:initialization_arguments) { { attribute_name => expected_value } }

      it { defines_the_ivar }

      it { assigns_to_the_ivar expected_value }
    end

    context 'when generating a predicate' do

      let(:access)               { :ro }
      let(:attribute_properties) { { predicate: true } }

      context 'when access is ro' do
        it { does_not_define_the_ivar }

        it { has_a getter    }
        it { has_a predicate }

        it { has_no clearer }
        it { has_no setter  }
      end

      context 'when access is rw' do
        let(:access) { :rw }

        it { does_not_define_the_ivar }

        it { has_a getter    }
        it { has_a setter    }
        it { has_a predicate }

        it { has_no clearer }
      end

      context 'when a true-ish value is set' do
        let(:initialization_arguments) { { attribute_name => 42 } }

        it 'evaluates to true' do
          expect(instance.send predicate).to be_true
        end
      end

      context 'when a false-ish value is set' do
        let(:initialization_arguments) { { attribute_name => nil } }

        it 'evaluates to true' do
          expect(instance.send predicate).to be_true
        end
      end

      context 'when the attribute is not set' do
        let(:initialization_arguments) { }

        it 'evaluates to false' do
          expect(instance.send predicate).to be_false
        end
      end

      it 'evaluates true when the value is set' do
        expect(instance.send predicate).to be_false
      end

    end

    context 'when generating a clearer' do

      let(:attribute_properties) { { clearer: true } }
      let(:old_value)            { 42 }
      let(:access)               { :ro }

      context 'when created :ro' do
        it { does_not_define_the_ivar }

        it { has_a getter  }
        it { has_a clearer }

        it { has_no predicate }
        it { has_no setter    }
      end

      context 'when created :rw' do
        let(:access) { :rw }

        it { does_not_define_the_ivar }

        it { has_a getter  }
        it { has_a clearer }
        it { has_a setter  }

        it { has_no predicate }
      end

      describe :clearer do

        it 'clears an attribute' do
          instance.instance_variable_set ivar, 42
          expect {
            instance.send clearer
          }.to change {instance.instance_variable_defined? ivar}.to false
        end
      end
    end

    context 'when an attribute is required for initialization' do

      let(:attribute_properties) { {required: true } }
      let(:value)  { 99 }

      it 'raises an exception when it is missing' do
        expect { instance }.to raise_error Reindeer::MissingParameter
      end

      context 'when a value is provided' do
        let(:initialization_arguments) { { attribute_name => value } }

        it { assigns_to_the_ivar value }
      end
    end

    context 'when handling defaults' do

      context 'if no default is provided' do
        let(:params) { { is: :rw } }

        it 'does not have a default' do
          expect(instance.send attribute_name).to be_nil
        end

        it { does_not_define_the_ivar }

        context 'with an initial value' do
          let(:initialization_arguments) { { attribute_name => 11 } }

          it 'does not change the actual value' do
            expect(instance.send attribute_name).to eq 11
          end
        end
      end

      context 'if a default is provided' do
        let(:default) { 99 }
        let(:attribute_properties)  { { default: default } }

        it 'uses the default when there is no value' do
          expect(instance.send attribute_name).to eq default
        end

        it 'does not change the actual value' do
          instance = example_class.new attribute_name: 62
          expect(instance.send attribute_name).to eq 62
        end

        it 'does not override false' do
          instance = example_class.new attribute_name: false
          expect(instance.send attribute_name).to eq false
        end

        it { does_not_define_the_ivar }
      end
    end

    describe :builder do

      let(:attribute_name) { :foo }

      let(:example_class) do
        props = { is: access }.merge(attribute_properties)
        example_class = Class.new do extend Reindeer
          has :foo, props
          def build_foo; 42; end
        end
        example_class
      end

      let(:attribute_properties) { { builder: :build_foo } }

      it 'uses the provided builder to build an attribute' do
        expect(instance.foo).to eq 42
      end

      it 'does not override an initialization value' do
        expect(example_class.new(foo: 99).foo).to eq 99
      end

      context 'when lazy' do

        let(:attribute_properties) { { builder: :build_foo, lazy: :build_foo } }

        let(:instance) { example_class.new }

        it { does_not_define_the_ivar }

        it 'calls the builder when an accessor is called' do
          instance.should_receive(:build_foo)
          instance.foo
        end

        it 'sets the attribute value to the built value' do
          expect(instance.foo).to eq instance.build_foo
        end
      end
    end
  end
end
