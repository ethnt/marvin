# Marvin

Marvin is a compiler written in Ruby.

## Installation

You'll first need the Marvin source. Clone it with Git:

```
$ git clone https://github.com/eturk/marvin.git
$ cd marvin/
```

All that is required to build Marvin is [Rubinius 3.5.0](http://rubinius.com/). It's recommended that you use something like [rbenv](https://github.com/rbenv/rbenv) to manage which Ruby version you're using.

Next, use Bundler to install all of the RubyGem dependencies:

```
$ bundle install
```

## Usage

### Running the test suite

You can run the test suite (RSpec and Cucumber) using the `test` Rake command:

```
$ bundle exec rake test
```

Alternatively, you can run RSpec and Cucumber individually:

```
$ bundle exec rake spec
$ bundle exec rake features
```

### Entering a console

You can use `pry` to enter a console to interact with Marvin directly:

```
$ bundle exec rake console
```
