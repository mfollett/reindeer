
shared_context 'common names' do
  let(:attribute_name) { :attribute_name             }
  let(:ivar)           { :"@#{attribute_name}"       }
  let(:getter)         { :attribute_name             }
  let(:setter)         { :"#{attribute_name}="       }
  let(:predicate)      { :"#{getter}?"               }
  let(:clearer)        { :"clear_#{attribute_name}!" }

  let(:access)         { :ro }

  let(:instance)       { example_class.new initialization_arguments }

  # Override to initialize an object with specific values
  let(:initialization_arguments) { {} }

  # Override to add properties beyond access control to the attribute
  let(:attribute_properties)     { {} }

  let(:example_class) do
    props = { is: access }.merge(attribute_properties)
    example_class = Class.new { extend Reindeer }
    example_class.has attribute_name, props
    example_class
  end

end

shared_context 'an attribute with access' do |access|
  include_context 'common names'

  let(:access) {access}
end

shared_context 'an attribute with a predicate and access' do |access|
  include_context 'an attribute with access', access

end

module ReindeerHelpers
  def has_a(method)
    expect(instance.methods).to include(method)
  end

  def has_no(method)
    expect(instance.methods).to_not include(method)
  end

  def defines_the_ivar
    expect(
      instance.instance_variable_defined? "@#{attribute_name}"
    ).to be_true
  end

  def does_not_define_the_ivar
    expect(
      instance.instance_variable_defined? "@#{attribute_name}"
    ).to be_false
  end

  def assigns_to_the_ivar(value)
    expect(
      instance.instance_variable_get :"@#{attribute_name}"
    ).to eq value
  end
end
