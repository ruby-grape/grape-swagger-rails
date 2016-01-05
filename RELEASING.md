# Releasing Grape-Swagger-Rails

There're no particular rules about when to release grape-swagger-rails. Release bug fixes frequenty, features not so frequently and breaking API changes rarely.

### Release

Run tests, check that all tests succeed locally.

```
bundle install
rake
```

Check that the last build succeeded in [Travis CI](https://travis-ci.org/ruby-grape/grape-swagger-rails) for all supported platforms.

Increment the version, modify [lib/grape-swagger-rails/version.rb](lib/grape-swagger-rails/version.rb).

*  Increment the third number if the release has bug fixes and/or very minor features, only (eg. change `0.1.0` to `0.1.1`).
*  Increment the second number if the release contains major features or breaking API changes (eg. change `0.1.0` to `0.2.0`).

Change "Next Release" in [CHANGELOG.md](CHANGELOG.md) to the new version.

```
### 0.1.1 (February 5, 2015)
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```
git add CHANGELOG.md lib/grape-swagger-rails/version.rb
git commit -m "Preparing for release, 0.1.1."
git push origin master
```

Release.

```
$ rake release

grape-swagger-rails 0.1.1 built to pkg/grape-swagger-rails-0.1.1.gem.
Tagged v0.1.1.
Pushed git commits and tags.
Pushed grape-swagger-rails 0.1.1 to rubygems.org.
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
Next Release
============

* Your contribution here.
```

Comit your changes.

```
git add CHANGELOG.md
git commit -m "Preparing for next release."
git push origin master
```
