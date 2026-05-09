# Releasing Grape-Swagger-Rails

There are no particular rules about when to release grape-swagger-rails.
Release bug fixes frequent, features not so frequently and breaking API changes rarely.

### Release

Release from a clean checkout of `master` after the release PR has been merged.

Run tests and build checks locally.

```
bundle install
yarn install --immutable
yarn typecheck
yarn build:frontend
git diff --exit-code app/assets/javascripts/grape_swagger_rails/index.js
bundle exec rake
```

Check that the latest [GitHub Actions](https://github.com/ruby-grape/grape-swagger-rails/actions) runs succeeded for both `Tests` and `Frontend`.

Increment the version, modify [lib/grape-swagger-rails/version.rb](lib/grape-swagger-rails/version.rb).

* Increment the third number if the release has bug fixes and/or very minor features, only (eg. change `0.1.0` to `0.1.1`).
* Increment the second number if the release contains major features or breaking API changes (eg. change `0.1.0` to `0.2.0`).

Change "Next Release" in [CHANGELOG.md](CHANGELOG.md) to the new version.

```
### 0.1.1 (February 5, 2015)
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Update [README.md](README.md) and [UPGRADING.md](UPGRADING.md) for any user-visible, compatibility, or breaking changes.

Commit your changes.

```
git add CHANGELOG.md README.md UPGRADING.md lib/grape-swagger-rails/version.rb
git commit -m "Preparing for release, 0.1.1."
git push origin master
```

Build the gem once before publishing to confirm packaging still works.

```
gem build grape-swagger-rails.gemspec
```

Release from a clean `master` checkout.

```
git checkout master
git pull --ff-only origin master
git status --short
bundle exec rake release

grape-swagger-rails 0.1.1 built to pkg/grape-swagger-rails-0.1.1.gem.
Tagged v0.1.1.
Pushed git commits and tags.
Pushed grape-swagger-rails 0.1.1 to rubygems.org.
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
### Next Release

* Your contribution here.
```

Commit your changes.

```
git add CHANGELOG.md
git commit -m "Preparing for next release."
git push origin master
```
