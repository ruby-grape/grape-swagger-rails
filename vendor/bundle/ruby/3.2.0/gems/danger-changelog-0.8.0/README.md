# Danger-Changelog

A plugin for [danger.systems](http://danger.systems) that obsessive-compulsively lints your project’s `CHANGELOG.md`.
It can make sure, for example, that changes are attributed properly, have a valid version number, a date in the ISO8601 format, balanced parenthesis and brackets, and that they’re always terminated with a period.

[![Gem Version](https://badge.fury.io/rb/danger-changelog.svg)](https://badge.fury.io/rb/danger-changelog)
[![Build Status](https://github.com/dblock/danger-changelog/actions/workflows/test.yml/badge.svg?branch=master&event=push)](https://github.com/dblock/danger-changelog/actions/workflows/test.yml)

# Table of Contents

- [What’s a correctly formatted CHANGELOG file?](#whats-a-correctly-formatted-changelog-file)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
  - [changelog.filename](#changelogfilename)
  - [changelog.format](#changelogformat)
  - [changelog.placeholder_line](#changelogplaceholder_line)
  - [changelog.ignore_files](#changelogignore_files)
- [Checks](#checks)
  - [changelog.check!](#changelogcheck)
    - [changelog.have_you_updated_changelog?](#changeloghave_you_updated_changelog)
    - [changelog.is_changelog_format_correct?](#changelogis_changelog_format_correct)
- [Contributing](#contributing)
- [Copyright](#copyright)

## What's a correctly formatted CHANGELOG file?

By design, `danger-changelog` is quite strict with what it allows as a valid changelog file, using the [Intridea style](doc/intridea.md), [used by this library itself](CHANGELOG.md). It also supports the [Keep a Changelog](doc/keep_a_changelog.md) format.

## Installation

Add `danger-changelog` to your Gemfile.

```
gem 'danger-changelog', '~> 0.6.0'
```

Call `changelog.check!` from your `Dangerfile`. Make a pull request and see this plugin in action.

## Usage

Methods and attributes from this plugin are available in your `Dangerfile` under the `changelog` namespace.

## Configuration

The following options and checks are supported.

### changelog.filename

Set the CHANGELOG file name, defaults to `CHANGELOG.md`.

```ruby
changelog.filename = 'CHANGES.md'
```

### changelog.format

Set the format of the CHANGELOG file.

```ruby
changelog.format = :keep_a_changelog
```

Available formats are [Intridea](doc/intridea.md) (default) and [Keep a Changelog](doc/keep_a_changelog.md).

### changelog.placeholder_line

Customize the `* Your contribution here.` line. Set the value to `nil` to stop checking for one.

```ruby
changelog.placeholder_line = "* Your change here.\n"
```

### changelog.ignore_files

Ignore additions and changes with a certain name or expression, default is to ignore `README.md` changes.

For example, ignore `UPGRADING.md` and all `.txt` files.

```ruby
changelog.ignore_files = ['README.md', 'UPGRADING.md', /\.txt$/]
```

## Checks

Invoke check methods.

### changelog.check!

Run all checks with defaults, including `have_you_updated_changelog?` and `is_changelog_format_correct?`.

#### changelog.have_you_updated_changelog?

Checks whether you have updated CHANGELOG.md.

![](images/have_you_updated_changelog.png)

#### changelog.is_changelog_format_correct?

Checks whether the CHANGELOG format is correct.

![](images/is_changelog_format_correct.png)

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright

Copyright (c) Daniel Doubrovkine, 2016-2019

MIT License, see [LICENSE](LICENSE.txt) for details.
