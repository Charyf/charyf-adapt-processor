# Adapt-Charyf

Adapt-Charyf is a ruby wrapper around Mycroft's Intent parser library [mycroft/Adapt](https://github.com/MycroftAI/adapt). This wrapper provides charyf interface to defining and determining intents.

# Getting Started

Add this line to your charyf application's Gemfile:

```ruby
gem 'adapt-chartf'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adapt-charyf
    
Make sure the python library is installed
```pip install -e git+https://github.com/mycroftai/adapt#egg=adapt-parser``` [or use pip3 if desired]

Adapt-charyf uses ```pycall``` gem to handle python calls.

## Usage

When launching any ruby application using adapt-charyf, ensure that   
```ENV['PYTHON'] = /path/to/python/with/adapt/libary```   
is set to python version that has adapt-parser installed.

Defining the intent is very similiar to original adapt library.

### Entities

Firstly we define entites that will occur in our utterances.

**Register an keyword entity**

```ruby
Skill.public_routing_for :adapt do |routing|
    routing.register_keywords 'greet', 'Hello', 'Hi'
end
```

Keyword entity is defined by its name *greet* and followed by all phrases in this entity.
For entity *greet* we define two works *Hi* and *Hello*.

**Register regex entity**

User may register regex entity as well. 

```ruby
Skill.public_routing_for :adapt do |routing|
    routing.register_regex 'in (?P<location>.*)'
end
```

Regex entity requires a regex with one named capture. This named capture is then used as the name of the entity.
Example above defines new regex entity with name *location*.

> Adapt regex entities use python's syntax as there is no current 1:1 mapping between ruby and python regex syntax. 
However defining named capture is very similiar.

All defined entities are available in the scope of particular skill and are not visible to other skills. 
Once can imagine defining entity *hello* as *Skill:Hello*, thus not coliding with other skills.

### Intent

Once our entities are defined and correctly named we can start building intents.

```ruby
Skill.public_routing_for :adapt do |routing|
    routing.intent('GreetIntent')
      .required('greet')
      #.optional('another_entity')
      .route_to('base', 'hello')
end
```

Example above defines new intent *GreetIntent*, with one required entity. We can also define optional entities which does not need to occur in the utterance.
Last step of defining is setting the *routing*. By specifying **route_to('base', 'hello')** we define that matched intent should be routed to **Skill::BaseController** into action **hello**.

Routing can't be defined outside the scope of the skill as it is automatically nested into skill namespace.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/adapt-charyf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CharyfAdaptProcessor project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/adapt-charyf/blob/master/CODE_OF_CONDUCT.md).
