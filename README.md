# Marvin

- **Author**: [Ethan Turkeltaub](http://ethnt.me)
- **License**: [MIT License](https://github.com/eturk/marvin/blob/master/LICENSE.md)

[![Build Status](https://travis-ci.org/eturk/marvin.svg?branch=master)](https://travis-ci.org/eturk/marvin)

> _Here I am, brain the size of a planet, and they ask me to compile code for a 6502a microprocessor. Call that job satisfaction? 'Cause I don't._
>
> &mdash;[Marvin](https://en.wikipedia.org/wiki/Marvin_(character))

## What is Marvin?

Marvin is an implementation of the Marist College CMPT 432 Compilers [language grammar](http://www.labouseur.com/courses/compilers/grammar.pdf). It targets the [6502a microprocessor](http://www.labouseur.com/commondocs/6502alan-instruction-set.pdf) and provides the front- and back-ends of a compiler.

Although Marvin uses [Rubinius](http://rubinius.com/) as a Ruby implementation, it does _not_ use it as an intermediate representation. In the future, it's possible that it will target Rubinius and [LLVM](http://llvm.org/) as well as provide its own for the 6502a microprocessor, but the initial goal is to provide all the functions of a compiler from source code to machine code.


## Installation

The only dependency that Marvin requires is Rubinius 3.14. All other RubyGems can be installed with Bundler.

### Installing dependencies on OS X

It's highly recommended that you install Homebrew, if you haven't already:

```
$ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

Next, install LLVM, rbenv and ruby-build using Homebrew:

```
$ brew install homebrew/versions/llvm35 rbenv ruby-build
```

You'll need to add to your `$PATH` to get rbenv to work globally. Head into your `~/.bash_profile` file using the text editor of your choice and add the following snippet:

```
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

_If you don't use Bash, something similar will work for ZSH and Fish, at least._

Restart your current shell:

```
$ exec $SHELL -l
```

Finally, you can go ahead and install Rubinius:

```
$ RUBY_CONFIGURE_OPTS=--llvm-path="/usr/local/Cellar/llvm35/3.5.1" rbenv install rbx-3.14
```

### Setting up Marvin

You'll need the Marvin source. Clone it with Git:

```
$ git clone https://github.com/eturk/marvin.git
$ cd marvin/
```

Next, use Bundler to install all of the RubyGem dependencies:

```
$ bundle install
```

Now you're ready to start using Marvin!

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

As a bonus, SimpleCov will generate a test coverage report when it finished. You can see it at `coverage/index.html`.

### Entering a console

You can use `pry` to enter a console to interact with Marvin directly:

```
$ bundle exec rake console
```

### Generating documentation

Marvin uses [YARD](https://github.com/lsegal/yard) for documentation:

```
$ bundle exec rake yard
```

### Running the code analyzer

Marvin uses the [Rubocop](https://github.com/bbatsov/rubocop) code analyzer to check the codebase against the Ruby best practices. You can call it with rake:

```
$ bundle exec rubocop
```
