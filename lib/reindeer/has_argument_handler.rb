class Reindeer::MissingAttributeName < ArgumentError; end

class Reindeer::HasArgumentHandler
  def initialize(parameters)
    raise Reindeer::MissingAttributeName if parameters[:attribute_name].nil?
    @parameters = parameters
  end

  def attribute_name
    @parameters[:attribute_name]
  end

  [:initializer_name, :getter_name].each do |attribute|
    define_method attribute do
      @parameters[attribute] || @parameters[:attribute_name]
    end
  end

  def setter_name
    setter_base_name.to_s + '='
  end

  def setter?
     :rw == @parameters[:is] || @parameters.has_key?(:setter_name)
  end

  def clearer_name
    @parameters[:clearer_name] || 'clear_' + setter_base_name.to_s + '!'
  end

  def predicate_name
    @parameters[:predicate_name] || getter_name.to_s + "?"
  end

  def accessor_type
    case is = @parameters[:is]
    when :ro
      :attr_reader
    when :rw
      :attr_accessor
    when nil
      nil
    else
      raise Reindeer::BadIs.new("#{is} invalid")
    end
  end

  private

  def setter_base_name
    (@parameters[:setter_name] || @parameters[:attribute_name])
  end
end
