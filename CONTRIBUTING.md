# Contributing to Grape-Swagger-Rails

This project is work of [many contributors](https://github.com/BrandyMint/grape-swagger-rails/graphs/contributors).
You're encouraged to submit [pull requests](https://github.com/BrandyMint/grape-swagger-rails/pulls),
[propose features and discuss issues](https://github.com/BrandyMint/grape-swagger-rails/issues).

In the examples below, substitute your Github username for `contributor` in URLs.

## Fork the Project

Fork the [project on Github](https://github.com/BrandyMint/grape-swagger-rails) and check out your copy.

```
git clone https://github.com/contributor/grape-swagger.git
cd grape-swagger
git remote add upstream https://github.com/BrandyMint/grape-swagger-rails.git
```

## Create a Topic Branch

Make sure your fork is up-to-date and create a topic branch for your feature or bug fix.

```
git checkout master
git pull upstream master
git checkout -b my-feature-branch
```

## Bundle Install and Test

Ensure that you can build the project and run tests.

```
bundle install
bundle exec rake
```

## Write Tests

Try to write a test that reproduces the problem you're trying to fix or describes a feature that you want to build.
Add to [spec](spec).

We definitely appreciate pull requests that highlight or reproduce a problem, even without a fix.

## Write Code

Implement your feature or bug fix.

Make sure that `bundle exec rake` completes without errors.

You might find it useful to iterate on code by running the test project from spec/dummy.

```
spec/dummy$ GRAPE_SWAGGER_VERSION=HEAD bundle install

Updating git://github.com/tim-vandecasteele/grape-swagger.git
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

Navigate to http://localhost:3000/swagger.

## Write Documentation

Document any external behavior in the [README](README.md).

## Push

```
git push origin my-feature-branch
```

## Make a Pull Request

Go to https://github.com/contributor/grape and select your feature branch.
Click the 'Pull Request' button and fill out the form. Pull requests are usually reviewed within a few days.

## Rebase

If you've been working on a change for a while, rebase with upstream/master.

```
git fetch upstream
git rebase upstream/master
git push origin my-feature-branch -f
```

## Check on Your Pull Request

Go back to your pull request after a few minutes and see whether it passed muster with Travis-CI. Everything should look green, otherwise fix issues and amend your commit as described above.

## Be Patient

It's likely that your change will not be merged and that the nitpicky maintainers will ask you to do more, or fix seemingly benign problems. Hang on there!

## Thank You

Please do know that we really appreciate and value your time and work. We love you, really.
