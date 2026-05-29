# Releasing Danger-Toc

There're no hard rules about when to release danger-toc. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

### Release

Install bundle, run tests, check that all tests succeed locally.

```
bundle install
rake
```

Check that the last build succeeded in [Travis CI](https://travis-ci.org/dblock/danger-toc) for all supported platforms.

Increment the version, modify [lib/toc/gem_version.rb](lib/toc/gem_version.rb).

Following the [Semantic Versioning](http://semver.org/):
*  Increment the third number if the release has bug fixes and/or very minor features with backward compatibility, only (eg. change `0.2.1` to `0.2.2`).
*  Increment the second number if the release contains major features or breaking API changes (eg. change `0.2.1` to `0.3.0`).

Create a new version and mark it as Next in [CHANGELOG.md](CHANGELOG.md).

```
### 0.2.2 (12/03/2016)
```

Remove the line with "* Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```
git add CHANGELOG.md lib/toc/gem_version.rb
git commit -m "Preparing for release, 0.2.2."
git push origin master
```

Release.

```
$ rake release

danger-toc 0.2.2 built to pkg/danger-toc-0.2.2.gem.
Tagged v0.2.2.
Pushed git commits and tags.
Pushed danger-toc 0.2.2 to rubygems.org.
```

### Prepare for the Next Version

Add the next release to [CHANGELOG.md](CHANGELOG.md).

```
### 0.2.3 (Next)

* Your contribution here.
```

Increment the third version number in [lib/toc/gem_version.rb](lib/toc/gem_version.rb).

Commit your changes.

```
git add CHANGELOG.md lib/toc/gem_version.rb
git commit -m "Preparing for next development iteration, 0.2.3."
git push origin master
```
