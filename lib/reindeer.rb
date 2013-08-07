require "reindeer/version"

module Reindeer
  def has(attribute_name, attribute_parameters)

    accessor_generator = case attribute_parameters[:is]
                         when :ro
                           :attr_reader
                         when :rw
                           :attr_accessor
                         end
    class_eval do
      send accessor_generator, attribute_name
    end
  end
end
