require "reindeer/version"

module Reindeer

  # Exception thrown when the :is argument is invalid.
  # XXX Note sure if this is a good name.
  class BadIs < ArgumentError; end

  def self.extended(host_class)
    host_class.class_exec do
      @@attributes_to_initialize = []
      def initialize(initial_values = {})
        initial_values ||= {}
        @@attributes_to_initialize.each do |attr|
          instance_variable_set :"@#{attr}", initial_values[attr]
        end if initial_values.count > 0

        super()
      end
    end
  end

  def has(attribute_name, attribute_parameters)

    accessor_generator = determine_accessor_generator attribute_parameters
    class_exec do
      send(accessor_generator, attribute_name) if accessor_generator

      @@attributes_to_initialize << attribute_name

      build_predicate(attribute_name) if attribute_parameters[:predicate]
      build_clearer(  attribute_name) if attribute_parameters[:clearer]
    end
  end

  private

  def build_predicate(attribute_name)
    define_method("#{attribute_name}?") do
      not send(attribute_name).nil?
    end
  end

  def build_clearer(attribute_name)
    puts "clear_#{attribute_name}!"
    define_method("clear_#{attribute_name}!") do
      instance_variable_set "@#{attribute_name}", nil
    end
  end

  def determine_accessor_generator(attribute_parameters)
    case is = attribute_parameters[:is]
    when :ro
      :attr_reader
    when :rw
      :attr_accessor
    when nil
      nil
    else
      raise BadIs.new("#{is} invalid")
    end
  end
end
