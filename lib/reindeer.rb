require "reindeer/version"

module Reindeer

  # Exception thrown when the :is argument is invalid.
  # XXX Note sure if this is a good name.
  class BadIs < ArgumentError; end

  def has(attribute_name, attribute_parameters)

    accessor_generator = case is = attribute_parameters[:is]
                         when :ro
                           :attr_reader
                         when :rw
                           :attr_accessor
                         when nil
                           nil
                         else
                           raise BadIs.new("#{is} invalid")
                         end
    class_eval do
      send accessor_generator, attribute_name
    end if is
  end
end
