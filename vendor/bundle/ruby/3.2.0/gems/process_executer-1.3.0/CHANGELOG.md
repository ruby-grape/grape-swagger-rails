# Changelog

All notable changes to the process_executer gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v1.3.0 (2025-02-26)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v1.2.0..v1.3.0)

Changes since v1.2.0:

* d1e189b build: add Ruby 3.4 to the CI workflow
* e805dfc feat: implement ProcessExecuter.run_command
* bad822f fix: update the yard build in the rake file and update included files
* 6fbdc5e feat: allow #spawn to accept file descriptors for redirection destination
* d745685 test: make it so that tests do not give unnecessary output

## v1.2.0 (2024-10-10)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v1.1.2..v1.2.0)

Changes since v1.1.2:

* 35663c9 chore: reset main branch to 1.x
* 39913bc build: remove semver pr label check
* 8ae8e34 build: enforce conventional commit message formatting
* f5b8c51 Release v2.0.0.pre1
* 8e15c39 Re-add require for 'forwardable'
* 4bba06e Fix flakey test that checks for thread to die
* 83bfd78 Remove unused require for 'forwardable' and 'ostruct'
* ea3ea3c Use shared Rubocop config
* ecd2cb5 Update copyright notice in this project
* 7d5bfe1 Update links in gemspec
* 797de91 Add Slack badge for this project in README
* 591b716 Update “Build Status” link the README
* 2fcd001 Update yardopts with new standard options
* 4e1de47 Standardize YARD and Markdown Lint configurations
* 929c680 Set JRuby --debug option when running tests in GitHub Actions workflows
* 71049cb Finish Integration of simplecov-rspec into the project
* 4fb44bb Update continuous integration and experimental ruby builds
* 289645c Depend on v1 of semver_pr_label_check
* 3c4d988 Update code climate test coverage reporter version
* 04103b4 Simplify how the experimental ruby builds are triggered
* 35840a4 Use a reusable workflow for the Semver PR label check
* 0d887f0 Update code climate test coverage reporter version
* bb7f73b Rename the experimental build workflow
* 035ce8a Fix the experimental CI Build workflow
* 3d739f4 Move CI builds using experimental Rubies to a different workflow
* c5ef6b0 Integrate simplecov-rspec to ensure code covage in CI builds
* f33707e Update development dependencies and examples (#45)

## v2.0.0.pre1 (2024-09-26)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v1.1.0..v2.0.0.pre1)

Changes since v1.1.0:

* 8e15c39 Re-add require for 'forwardable'
* 4bba06e Fix flakey test that checks for thread to die
* 83bfd78 Remove unused require for 'forwardable' and 'ostruct'
* ea3ea3c Use shared Rubocop config
* ecd2cb5 Update copyright notice in this project
* 7d5bfe1 Update links in gemspec
* 797de91 Add Slack badge for this project in README
* 591b716 Update “Build Status” link the README
* 2fcd001 Update yardopts with new standard options
* 4e1de47 Standardize YARD and Markdown Lint configurations
* 929c680 Set JRuby --debug option when running tests in GitHub Actions workflows
* 71049cb Finish Integration of simplecov-rspec into the project
* 4fb44bb Update continuous integration and experimental ruby builds
* 289645c Depend on v1 of semver_pr_label_check
* 3c4d988 Update code climate test coverage reporter version
* 04103b4 Simplify how the experimental ruby builds are triggered
* 35840a4 Use a reusable workflow for the Semver PR label check
* 0d887f0 Update code climate test coverage reporter version
* bb7f73b Rename the experimental build workflow
* 035ce8a Fix the experimental CI Build workflow
* 3d739f4 Move CI builds using experimental Rubies to a different workflow
* c5ef6b0 Integrate simplecov-rspec to ensure code covage in CI builds
* f33707e Update development dependencies and examples (#45)

## v1.1.0 (2024-02-02)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v1.0.2..v1.1.0)

Changes since v1.0.2:

* a473281 ProcessExecuter.spawn should indicate if the subprocess timed out or not (#43)

## v1.0.2 (2024-02-01)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v1.0.1..v1.0.2)

Changes since v1.0.1:

* 76ffb91 An invalid timeout value should raise an ArgumentError (#41)
* b748819 Release v1.0.1 (#40)

## v1.0.1 (2024-01-04)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v1.0.0..v1.0.1)

Changes since v1.0.0:

* f434aa1 Add an experimental build for jruby-head on windows (#15)
* 97dbcf5 Make updates resulting from doc review (#38)
* 93eab18 Release v1.0.0 (#37)

## v1.0.0 (2023-12-31)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.7.0..v1.0.0)

Changes since v0.7.0:

* e11f03e Separate semver PR label check into its own workflow (#36)
* eabcc3e Update min req Ruby version from 2.7 to 3.0 (#32)
* 5483bb8 Update spec_helper.rb to new standard (#31)
* 4a27341 Update all development dependencies to latest versions (#30)
* ea7513d Enforce that a semver label is present on PRs (#28)
* 0aa26cd Instruct Rubocop that dev deps go in gemspec (#29)
* 53cb526 Add a truffle-ruby build on ubuntu (#18)

## v0.7.0 (2023-02-17)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.6.1..v0.7.0)

Changes since v0.6.1:

* c5c07fd Reduce the time spent waiting for output (#25)

## v0.6.1 (2023-02-12)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.6.0..v0.6.1)

Changes since v0.6.0:

* 34b28a0 Documentation cleanup (#23)

## v0.6.0 (2023-02-12)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.5.0..v0.6.0)

Changes since v0.5.0:

* 2a22dbd Fix intermittent test failures (#21)
* e3afaa3 Add build for MRI Ruby 3.2 on unbuntu-latest (#20)
* 17522ac Use latest create_release_version gem (#19)
* ba1fb2d Read remaining data from pipe_reader when closing a MonitoredPipe (#17)
* 8422aa9 Release v0.5.0

## v0.5.0 (2022-12-12)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.4.0...v0.5.0)

* c6d8de9 Workaround a problem with SimpleCov / JRuby
* c480b5f Increase time to wait for results from a writer throwing an exception
* 1934563 Handle exceptions from writers within MonitoredPipe
* e948ada Increase default chunk_size to 100_000 bytes
* 5eb2c24 Update documentation for ProcessExecuter#spawn
* a3a4217 Release v0.4.0

## v0.4.0 (2022-12-06)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.3.0...v0.4.0)

* 9ac17a4 Remove build using jruby-head on windows
* d36d131 Work around a SimpleCov problem when using JRuby
* b6b3a19 Remove unused Status and Process classes
* a5cdf04 Allow 100% coverage check to be skipped
* a3fa1f5 Output coverage details when coverage is below 100%
* 6a9a417 Refactor monitor so that closing the pipe is on the monitoring thread
* 65ee9a2 Add JRuby and Windows builds
* 2e713e3 Release v0.3.0

## v0.3.0 (2022-12-01)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.2.0...v0.3.0)

* 6e2cdf1 Completely refactor to a single ProcessExecuter.spawn method (#7)
* 6da57ec Add CodeClimate badges to README.md (#6)
* eebd6ae Add front matter and v0.1.0 release to changelog (#5)
* 78cb9e5 Release v0.2.0

## v0.2.0 (2022-11-16)

[Full Changelog](https://github.com/main-branch/process_executer/compare/v0.1.0...v0.2.0)

* 8b70ac0 Use the create_github_release gem to make the release PR (#2)
* 4b2700e Add ProcessExecuter#execute to execute a command and return the result (#1)

## v0.1.0 (2022-10-20)

Initial release of an empty project
