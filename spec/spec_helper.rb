require 'reindeer'
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |c|
  c.include ReindeerHelpers
end
