# Danger Plugin API contract

This repo contains a single gem, it represents the current version of the API, and what the minimum version of Danger supports it.

Check the current version by clicking: [lib/danger/plugin/api/version.rb](lib/danger/plugin/api/version.rb).

This frees plugin authors from being tied to a project which is aggressive on [semantic versioning](http://semver.org). As long as the plugin API stays the same
then as an author you can be safe in the knowledge that a version bump on Danger has not changed the external API. 

## What do I define as a public API?

Well that one is a bit tricky, for plugins that is anything that can be found on the [Danger.Systems#reference](http://danger.systems/reference.html). Additions to the exposed DSL probably won't get bumps to this gem's versions, but breaking changes e.g. removals or renames definitely will.  

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/danger-plugin-api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

