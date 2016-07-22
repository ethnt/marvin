# Marvin

- **Author**: [Ethan Turkeltaub](http://ethnt.me)
- **License**: [MIT License](https://github.com/eturk/marvin/blob/master/LICENSE.md)

[![CircleCI](https://img.shields.io/circleci/project/eturk/marvin.svg?maxAge=2592000?style=flat-square)](https://circleci.com/gh/eturk/marvin/tree/master) [![Code Climate](https://img.shields.io/codeclimate/github/eturk/marvin.svg?maxAge=2592000?style=flat-square)](https://codeclimate.com/github/eturk/marvin) [![Code Climate](https://img.shields.io/codeclimate/coverage/github/eturk/marvin.svg?maxAge=2592000?style=flat-square)](https://codeclimate.com/github/eturk/marvin/coverage)

> _Here I am, brain the size of a planet, and they ask me to compile code. Call that job satisfaction? 'Cause I don't._
>
> &mdash;[Marvin](https://en.wikipedia.org/wiki/Marvin_(character))

## What is Marvin?

Marvin is a toy language written in Ruby using [RLTK](https://github.com/chriswailes/RLTK). It's not meant for production use, but just as a way to explore writing compilers and interpreters.

Here's an quick example of a Marvin program that takes a width and a height, computes the area of those two measurements, and prints the result:

```
fun area(width, height) {
  return width * height
}

a = area(4, 8)

print(a) # => 32
```

## Installation

Marvin requires two external dependencies:

- [Ruby](http://ruby-lang.org) 2.3.1
- [LLVM](http://llvm.org/) 3.5

### Installing Marvin on macOS

It's highly recommended that you install [Homebrew](http://brew.sh/), if you haven't already:

```
$ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
```

Next, install [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build) using Homebrew:

```
$ brew install rbenv ruby-build
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

Finally, you can go ahead and install Ruby:

```
$ rbenv install 2.3.1
```

All you need to do is install the dependencies using [Bundler](http://bundler.io/).

```
$ bundle install
```

Then you’ll need to install LLVM. The version of LLVM that we use is a bit tempermental to install, so we need to install the `HEAD` development versions of some its dependencies as well:

```
$ brew install --HEAD isl
$ brew install --HEAD cloog
$ brew install --rtti --with-clang --with-libcxx --with-shared --HEAD llvm35
```

Grab a coffee, this will take a while.

There is [an open issue with FFI](https://github.com/ffi/ffi/issues/461) (a dependency of RCGTK) that prevents it from finding dylib without an absolute path. It also ignores the environment variables that tell it the paths to look in. To avoid this, manually copy the LLVM 3.5 dylib to the correct directory.

```
$ cp /usr/local/lib/llvm-3.5/lib/libLLVM-3.5.dylib /usr/local/lib/
```

After this, you're (finally) all set!
