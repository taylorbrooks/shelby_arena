# Shelby Arena Ruby Client ![example workflow](https://github.com/taylorbrooks/shelby_arena/actions/workflows/test.yml/badge.svg)

A Ruby wrapper for the Shelby Arena API

### Installation
Add this line to your application's Gemfile:
````ruby
  # in your Gemfile
  gem 'shelby_arena', '~> 0.0.1'

  # then...
  bundle install
````

### Usage
````ruby
  # Authenticating with username and password
  client = ShelbyArena::Client.new(
    url: ...,
    username: ...,
    password: ...,
  )

  # Authenticating with authorization token
  client = ShelbyArena::Client.new(
    url: ...,
    authorization_token: ...,
  )

  # Find a specific person
  client.find_person_by_email('gob@bluthco.com')
  client.find_person_by_name('Tobias Funke')
````

### History

View the [changelog](https://github.com/taylorbrooks/shelby_arena/blob/master/CHANGELOG.md)
This gem follows [Semantic Versioning](http://semver.org/)

### Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/taylorbrooks/shelby_arena/issues)
- Fix bugs and [submit pull requests](https://github.com/taylorbrooks/shelby_arena/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

### Copyright
Copyright (c) 2023 Taylor Brooks. See LICENSE for details.
