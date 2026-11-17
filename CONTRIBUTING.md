# Contributing to Grape-Swagger-Rails

This project is work of [many contributors](https://github.com/ruby-grape/grape-swagger-rails/graphs/contributors). You're encouraged to submit [pull requests](https://github.com/ruby-grape/grape-swagger-rails/pulls), [propose features and discuss issues](https://github.com/ruby-grape/grape-swagger-rails/issues).

In the examples below, substitute your GitHub username for `contributor` in URLs.

## Fork the Project

Fork the [project on GitHub](https://github.com/ruby-grape/grape-swagger-rails) and check out your copy.

```sh
git clone https://github.com/contributor/grape-swagger-rails.git
cd grape-swagger-rails
git remote add upstream https://github.com/ruby-grape/grape-swagger-rails.git
```

## Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```sh
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

## Bundle Install and Test

Use Ruby 3.2 or newer and Node.js 26 LTS for development. Install [actionlint](https://github.com/rhysd/actionlint#installation) for workflow checks and Firefox for browser tests. Selenium Manager resolves the matching geckodriver automatically.

```sh
bundle install
npm install --global corepack@0.36.0
corepack enable
yarn install --immutable
bundle exec rake
```

The default Rake task runs Ruby and workflow lint before the RSpec suite. `bundle exec rake lint` runs just these checks.

Run browser tests without a display with `HEADLESS=true bundle exec rake spec`. Set `ASSET_PIPELINE=propshaft` to exercise Propshaft instead of the default Sprockets pipeline. CI tests both pipelines on Ruby 3.2, 3.3, 3.4, and 4.0, with JSON 2/3 and Linux/macOS coverage. Ruby 3.2 remains the consumer compatibility floor even though it is end-of-life; lint and build jobs use current stable runtimes.

### CI Workflows

`Test` and `Lint` run independently on pull requests and pushes to `master`. `Lint` also type-checks and rebuilds the frontend, then rejects uncommitted changes to generated assets. Dependency caches are keyed by the relevant lockfile and platform.

Danger runs in PR CI, not as routine local validation. Its read-only report job remains separate from the privileged comment workflow; the latter does not check out or execute PR code. The existing changelog automation only writes branches in the main repository.

## Write Tests

Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build.
Add to [spec](spec).

We definitely appreciate pull requests that highlight or reproduce a problem, even without a fix.

## Write Code

Implement your feature or bug fix.

Ruby style is enforced with [RuboCop](https://github.com/bbatsov/rubocop).
Run `bundle exec rubocop` and fix any style issues highlighted.

Make sure that `bundle exec rake` completes without errors.

You might find it useful to iterate on code by running the test project from spec/dummy.

```text
spec/dummy$ GRAPE_SWAGGER_VERSION=HEAD bundle install

Updating git://github.com/ruby-grape/grape-swagger.git
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
...

spec/dummy$ GRAPE_SWAGGER_VERSION=HEAD rails s
=> Booting WEBrick
=> Rails 4.1.8 application starting in development on http://0.0.0.0:3000
=> Run `rails server -h` for more startup options
=> Notice: server is listening on all interfaces (0.0.0.0). Consider using 127.0.0.1 (--binding option)
=> Ctrl-C to shutdown server
...
```

Navigate to <http://localhost:3000/swagger>.

## Write Documentation

Document any external behavior in the [README](README.md).

## Update Changelog

Add a line to [CHANGELOG](CHANGELOG.md) under *Next Release*.
Make it look like every other line, including your name and link to your Github account.

## Push

```sh
git push origin my-feature-branch
```

## Make a Pull Request

Go to <https://github.com/contributor/grape-swagger-rails> and select your feature branch.
Click the 'Pull Request' button and fill out the form. Pull requests are usually reviewed within a few days.

## Update CHANGELOG Again

Update the [CHANGELOG](CHANGELOG.md) with the pull request number. A typical entry looks as follows.

```markdown
* [#123](https://github.com/ruby-grape/grape-swagger-rails/pull/123): Reticulated splines - [@contributor](https://github.com/contributor).
```

Amend your previous commit and force push the changes.

```sh
git commit --amend
git push origin my-feature-branch -f
```

## Rebase

If you've been working on a change for a while, rebase with upstream/master.

```sh
git fetch upstream
git rebase upstream/master
git push origin my-feature-branch -f
```

## Check on Your Pull Request

Check the `Test`, `Lint`, and Danger results on the pull request. Everything should look green; otherwise fix issues and update the PR.

## Be Patient

Maintainers may ask for changes before merging, including fixes for seemingly minor problems. Hang on there!

## Preparing a Release

Run `bin/bump 1.0.11` with the desired new version. This updates the gem version and moves all entries under `Next Release` into a new section dated today, leaving `Your contribution here.` under `Next Release`. It refuses empty releases and versions that are not newer than the current version.

Review the diff, commit it, and follow the usual gem release process. The script does not commit, tag, push, or publish the gem.

## Thank You

Please do know that we really appreciate and value your time and work. We love you, really.
