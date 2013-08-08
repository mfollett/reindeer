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

    its(:attribute_name)   { should eq attribute_name }
    its(:initializer_name) { should eq attribute_name }
    its(:getter_name)      { should eq attribute_name }
    its(:setter_name)      { should eq attribute_name }
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

    its(:attribute_name)   { should eq attribute_name   }
    its(:initializer_name) { should eq initializer_name }
    its(:getter_name)      { should eq getter_name      }
    its(:setter_name)      { should eq setter_name      }
  end

  describe :accessor_type do

    subject do
      subject_class.new(attribute_name: 'a', is: access_control).accessor_type
    end

    context 'when passed :ro' do
      let(:access_control) { :ro }

      it { should eq :attr_reader }
    end

    context 'when passed :rw' do
      let(:access_control) { :rw }

      it { should eq :attr_accessor }
    end

    context 'when passed invalid data' do
      let(:access_control) { :not_a_valid_value }

      it 'raises BadIs' do
        expect {subject} .to raise_error Reindeer::BadIs
      end
    end
  end
end
