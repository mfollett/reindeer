require 'reindeer/has_argument_handler'

describe Reindeer::HasArgumentHandler do

  let(:subject_class) {Reindeer::HasArgumentHandler}

  describe :initialize do
    let(:expected_value) { { is: :ro, attribute_name: 'a' } }
    let(:bad_creation)   { subject_class.new( {} ) }

    it 'records the params' do
      instance = Reindeer::HasArgumentHandler.new(expected_value)
      expect(instance.instance_variable_get :@parameters).to eq expected_value
    end

    it 'raises an error if :attribute_name is not provided' do
      expect { bad_creation }.to raise_error Reindeer::MissingAttributeName
    end
  end

  context 'when only provided an attribute name' do

    let(:attribute_name) { :some_string }

    subject do
      subject_class.new attribute_name: attribute_name
    end

    its(:attribute_name)   { should eq attribute_name            }
    its(:initializer_name) { should eq attribute_name            }
    its(:getter_name)      { should eq attribute_name            }
    its(:setter_name)      { should eq attribute_name.to_s + '=' }
    its(:clearer_name)     { should eq 'clear_' + attribute_name.to_s + '!' }
    its(:predicate_name)   { should eq attribute_name.to_s + '?' }
  end

  context 'when provided all possible names' do

    let(:attribute_name)   { :some_value       }
    let(:initializer_name) { :some_init_value  }
    let(:getter_name)      { :some_getter_name }
    let(:setter_name)      { :some_setter_name }

    subject do
      subject_class.new attribute_name:   attribute_name,
                        initializer_name: initializer_name,
                        getter_name:      getter_name,
                        setter_name:      setter_name
    end

    its(:attribute_name)   { should eq attribute_name         }
    its(:initializer_name) { should eq initializer_name       }
    its(:getter_name)      { should eq getter_name            }
    its(:setter_name)      { should eq setter_name.to_s + '=' }
    its(:clearer_name)     { should eq 'clear_' + setter_name.to_s + '!' }
    its(:predicate_name)   { should eq getter_name.to_s + '?' }
  end

  describe :setter? do
    it 'is true when :rw is set' do
      expect(subject_class.new(attribute_name: :a, is: :rw).setter?).to be_true
    end

    it 'is true when :setter_name is set' do
      result = subject_class.new(attribute_name: :a, setter_name: :foo).setter?
      expect(result).to be_true
    end
  end
end
