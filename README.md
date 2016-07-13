# Marvin

- **Author**: [Ethan Turkeltaub](http://ethnt.me)
- **License**: [MIT License](https://github.com/eturk/marvin/blob/master/LICENSE.md)

[![CircleCI](https://img.shields.io/circleci/project/eturk/marvin.svg?maxAge=2592000?style=flat-square)](https://circleci.com/gh/eturk/marvin/tree/master) [![Code Climate](https://img.shields.io/codeclimate/github/eturk/marvin.svg?maxAge=2592000?style=flat-square)](https://codeclimate.com/github/eturk/marvin) [![Code Climate](https://img.shields.io/codeclimate/coverage/github/eturk/marvin.svg?maxAge=2592000?style=flat-square)](https://codeclimate.com/github/eturk/marvin/coverage)

> _Here I am, brain the size of a planet, and they ask me to compile code. Call that job satisfaction? 'Cause I don't._
>
> &mdash;[Marvin](https://en.wikipedia.org/wiki/Marvin_(character))

## What is Marvin?

Marvin is a toy language written in Ruby using [RLTK](https://github.com/chriswailes/RLTK). It's not meant for production use, but just as a way to explore writing compilers and interpreters.

Here's an quick example of a Marvin program that takes a radius of a circle and computes the circumference:

```
fun main(radius) {
  return circumference(radius)
}

fun circumference(radius) {
  pi = 3.14159

  return 2 * radius * pi
}
```

## Installation

The only external dependency is [Ruby](http://ruby-lang.org). It's recommended that you use [rbenv](https://github.com/rbenv/rbenv) or a similar product to manage your Ruby versions.

All you need to do is install the dependencies using [Bundler](http://bundler.io/).

```
$ bundle install
```
