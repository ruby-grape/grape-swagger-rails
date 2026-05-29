# The ProcessExecuter Gem

[![Gem Version](https://badge.fury.io/rb/process_executer.svg)](https://badge.fury.io/rb/process_executer)
[![Documentation](https://img.shields.io/badge/Documentation-Latest-green)](https://rubydoc.info/gems/process_executer/)
[![Change Log](https://img.shields.io/badge/CHANGELOG-Latest-green)](https://rubydoc.info/gems/process_executer/file/CHANGELOG.md)
[![Build Status](https://github.com/main-branch/process_executer/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/main-branch/process_executer/actions/workflows/continuous-integration.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/0b5c67e5c2a773009cd0/maintainability)](https://codeclimate.com/github/main-branch/process_executer/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0b5c67e5c2a773009cd0/test_coverage)](https://codeclimate.com/github/main-branch/process_executer/test_coverage)
[![Conventional
Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)
[![Slack](https://img.shields.io/badge/slack-main--branch/process__executer-yellow.svg?logo=slack)](https://main-branch.slack.com/archives/C07NG2BPG8Y)

* [Usage](#usage)
  * [ProcessExecuter.run](#processexecuterrun)
  * [ProcessExecuter::MonitoredPipe](#processexecutermonitoredpipe)
  * [ProcessExecuter.spawn](#processexecuterspawn)
* [Installation](#installation)
* [Contributing](#contributing)
  * [Reporting Issues](#reporting-issues)
  * [Developing](#developing)
  * [Commit message guidelines](#commit-message-guidelines)
  * [Pull request guidelines](#pull-request-guidelines)
  * [Releasing](#releasing)
* [License](#license)

## Usage

[Full YARD documentation](https://rubydoc.info/gems/process_executer/) for this
gem is hosted on RubyGems.org. Read below of an overview and several examples.

This gem contains the following important classes:

### ProcessExecuter.run

`ProcessExecuter.run` execute the given command as a subprocess blocking until it is finished.

A Result object is returned which includes the process's status and output.

Supports the same features as
[Process.spawn](https://docs.ruby-lang.org/en/3.3/Process.html#method-c-spawn).
In addition, it (1) blocks until the command has exited, (2) captures stdout and
stderr to a buffer or file, and (3) can optionally kill the command if it exceeds
an timeout.

This command takes two forms:

1. When passing a single string the command is passed to a shell:

    `ProcessExecuter.run([env, ] command_line, options = {}) ->` {ProcessExecuter::Command::Result}

2. When passing an array of strings the command is run directly (bypassing the shell):

    `ProcessExecuter.run([env, ] exe_path, *args, options = {}) ->` {ProcessExecuter::Command::Result}

Argument env, if given, is a hash that affects ENV for the new process; see
[Execution
Environment](https://docs.ruby-lang.org/en/3.3/Process.html#module-Process-label-Execution+Environment).

Argument options is a hash of options for the new process; see the options listed below.

See comprehensive examples in the YARD documentation for this method.

### ProcessExecuter::MonitoredPipe

`ProcessExecuter::MonitoredPipe` streams data sent through a pipe to one or more writers.

When a new `MonitoredPipe` is created, a pipe is created (via IO.pipe) and
a thread is created which reads data as it is written written to the pipe.

Data that is read from the pipe is written one or more writers passed to
`MonitoredPipe#initialize`.

This is useful for streaming process output (stdout and/or stderr) to anything that has a
`#write` method: a string buffer, a file, or stdout/stderr as seen in the following example:

```ruby
require 'stringio'
require 'process_executer'

output_buffer = StringIO.new
out_pipe = ProcessExecuter::MonitoredPipe.new(output_buffer)
pid, status = Process.wait2(Process.spawn('echo "Hello World"', out: out_pipe))
output_buffer.string #=> "Hello World\n"
```

`MonitoredPipe#initialize` can take more than one writer so that pipe output can be
streamed (or `tee`d) to multiple writers at the same time:

```ruby
require 'stringio'
require 'process_executer'

output_buffer = StringIO.new
output_file = File.open('process.out', 'w')
out_pipe = ProcessExecuter::MonitoredPipe.new(output_buffer, output_file)
pid, status = Process.wait2(Process.spawn('echo "Hello World"', out: out_pipe))
output_file.close
output_buffer.string #=> "Hello World\n"
File.read('process.out') #=> "Hello World\n"
```

Since the data is streamed, any object that implements `#write` can be used. For insance,
you can use it to parse process output as a stream which might be useful for long XML
or JSON output.

### ProcessExecuter.spawn

`ProcessExecuter.spawn` has the same interface as `Process.spawn` but has two
important behaviorial differences:

1. It blocks until the subprocess finishes
2. A timeout can be specified using the `:timeout` option

If the command does not terminate before the timeout, the process is killed by
sending it the SIGKILL signal. The returned status object's `timeout?` attribute will
return `true`. For example:

```ruby
status = ProcessExecuter.spawn('sleep 10', timeout: 0.01)
status.signaled? #=> true
status.termsig #=> 9
status.timeout? #=> true
```

## Installation

Install the gem and add to the application's Gemfile by executing:

```shell
bundle add process_executer
```

If bundler is not being used to manage dependencies, install the gem by executing:

```shell
gem install process_executer
```

## Contributing

### Reporting Issues

Bug reports and other support requests are welcome on [this project's
GitHub issue tracker](https://github.com/main-branch/process_executer)

### Developing

Clone the repo, run `bin/setup` to install dependencies, and then run `rake spec` to
run the tests. You can also run `bin/console` for an interactive prompt that will
allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Commit message guidelines

All commit messages must follow the [Conventional Commits
standard](https://www.conventionalcommits.org/en/v1.0.0/). This helps us maintain a
clear and structured commit history, automate versioning, and generate changelogs
effectively.

To ensure compliance, this project includes:

* A git commit-msg hook that validates your commit messages before they are accepted.

  To activate the hook, you must have node installed and run `npm install`.

* A GitHub Actions workflow that will enforce the Conventional Commit standard as
  part of the continuous integration pipeline.

  Any commit message that does not conform to the Conventional Commits standard will
  cause the workflow to fail and not allow the PR to be merged.

### Pull request guidelines

All pull requests must be merged using rebase merges. This ensures that commit
messages from the feature branch are preserved in the release branch, keeping the
history clean and meaningful.

### Releasing

In the root directory of this project with the `main` branch checked out, run
the following command:

```shell
create-github-release {major|minor|patch}
```

Follow the directions given by the `create-github-release` to publish the new version
of the gem.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
