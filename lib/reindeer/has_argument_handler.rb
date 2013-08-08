class Reindeer::MissingAttributeName < ArgumentError; end

class Reindeer::HasArgumentHandler
  def initialize(parameters)
    raise Reindeer::MissingAttributeName if parameters[:attribute_name].nil?
    @parameters = parameters
  end

  def attribute_name
    @parameters[:attribute_name]
  end

  [:initializer_name, :getter_name, :setter_name].each do |attribute|
    define_method attribute do
      @parameters[attribute] || @parameters[:attribute_name]
    end
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
end
