# Reindeer

Reindeer is an implementation of [Moose-style](http://moose.iinteractive.com) sugar in the Ruby language. It
provides simple methods to declare complex requirements on attributes.

## Installation

Add this line to your application's Gemfile:

    gem 'reindeer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reindeer

## Usage

Reindeer allows developers to quickly declare complex attributes on their class.

```ruby
require 'reindeer'

class Person
  has :name,
    is:        :rw,
    required:  true,

  has :ssn,
    is:        :ro,
    required:  true,

  has :favorite_color,
    is:        :rw,
    required:  false,
    predicate: true,
    clearer:   true

  def see_a_favorite_color
    if favorite_color? # generated as predicate for favorite_color
      puts "#{name} sees a #{favorite_color} painting!" # generated accessors
    else
      puts "#{name} sees only dull, bland things."
  end
end

```

Generates several new accessors and methods for the person class, including:
* An initializer that takes a hash that must have name & SSN or a Reindeer::MissingProperty is thrown. And can take a favorite_color.
* Getters for name, ssn, and favorite color, as well as setter for name and favorite color.
* A clearer method for favorite color, `clear_favorite_color!`.
* A predicate method for favorite color, `favorite_color?`.

An axample of uing an instance of this would be:

```ruby
bob = Person.new( name: 'Bob Boberson', ssn: '123-45-6789', favorite_color: 'blue' )
bob.see_a_favorite_color

failed_person = Person.new( ) # Throws an exception
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
