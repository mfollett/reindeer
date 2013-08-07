# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reindeer/version'

Gem::Specification.new do |gem|
  gem.name          = 'reindeer'
  gem.version       = Reindeer::VERSION
  gem.authors       = ['Matt Follett']
  gem.email         = ['matt.follett@gmail.com']
  gem.description   = 'Convenient, powerful class declaration'
  gem.summary       = 'Reindeer provides powerful abstractions and convenience methods for declaring classes.'
  gem.homepage      = 'http://www.mfollett.com/reindeer'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
end
