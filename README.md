# Prolog::UseCases

This Gem contains proprietary use-case domain logic for the Meldd application (the "App"). Initially developed as a single Gem, it may be decomposed as updates to existing use-case logic force rerelease; that rerelease will consist of this Gem without the affected use case; a second Gem containing *only* the affected use case, and a dependency from the new release of this Gem on the new (single-case) Gem.

This defines, in *completely* delivery system-agnostic fashion, what the business rules and actions are, as encapsulated within command-pattern use cases. That is, an object's command method will have a specific set of inputs and/or properties that can be set on the object; the command method is then called; after which the exposed results of the action may be retrieved and analysed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prolog-use_cases'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prolog-use_cases

## Usage

API specifications and example code for the classes defined in this Gem will be developed externally. (**TBD:** Link to relevant document.)

## Development

This Gem was developed under MRI Ruby 2.3. If you're reading this, this document assumes that you have access to corporate development standards and workflows, which are incorporated herein by reference.

The original generated README had the following text here which may still be useful:

> After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
>
> To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Legal

Copyright ©2016, Prolog Systems (Singapore) Pte Ltd as an unpublished, proprietary work. Contact jeff.dickey@theprolog.com with any questions or concerns.
