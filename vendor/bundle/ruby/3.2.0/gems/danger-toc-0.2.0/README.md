# danger-toc

A plugin for [danger.systems](http://danger.systems) that makes sure your project’s `README.md` has a TOC.

[![Gem Version](https://badge.fury.io/rb/danger-toc.svg)](https://badge.fury.io/rb/danger-toc)
[![Build Status](https://travis-ci.org/dblock/danger-toc.svg?branch=master)](https://travis-ci.org/dblock/danger-toc)

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [toc.files](#tocfiles)
  - [toc.header](#tocheader)
  - [toc.check!](#toccheck)
- [Contributing](#contributing)
- [Copyright](#copyright)

## Installation

Add `danger-toc` to your Gemfile.

```
gem 'danger-toc', '~> 0.1'
```

Add `toc.check` to your Dangerfile. Make a pull request and see this plugin in action.

<img src='images/toc-missing.png'>

## Usage

Methods and settings from this plugin are available in your `Dangerfile` under the `toc` namespace.

### toc.files

List of files to ensure TOC in, default is `README.md`.

```ruby
config.files = [ 'README.md', 'DEV.md' ]
```

### toc.header

The Table of Contents header, without `#`, default is `Table of Contents`.

```ruby
config.header = 'Custom Table of Contents'
```

### toc.check!

Run all checks.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright

Copyright (c) Daniel Doubrovkine, 2017-2019

MIT License, see [LICENSE](LICENSE.txt) for details.
