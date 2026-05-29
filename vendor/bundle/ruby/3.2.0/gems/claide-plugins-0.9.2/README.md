# CLAide plugins

[![Build Status](https://img.shields.io/travis/CocoaPods/cocoapods-plugins/master.svg?style=flat)](https://travis-ci.org/CocoaPods/cocoapods-plugins)
[![Coverage](https://img.shields.io/codeclimate/coverage/github/CocoaPods/cocoapods-plugins.svg?style=flat)](https://codeclimate.com/github/CocoaPods/cocoapods-plugins)
[![Code Climate](https://img.shields.io/codeclimate/github/CocoaPods/cocoapods-plugins.svg?style=flat)](https://codeclimate.com/github/CocoaPods/cocoapods-plugins)

CLAide plugin which shows info about available CLAide plugins or helps you get started developing a new plugin. Yeah, it's very meta. 

It provides the foundations for CocoaPods and Danger's plugin infrastructure.

## Installation

This isn't really a user-facing gem, you need to add it to your library.

Here is how it is added into Danger:

```ruby
module Danger
  class Runner < CLAide::Command
    require "danger/commands/init"
    require "danger/commands/local"
    require "danger/commands/systems"

    # manually add claide plugins as subcommands
    require "claide_plugin"
    @subcommands << CLAide::Command::Plugins
    CLAide::Plugins.config =
      CLAide::Plugins::Configuration.new(
        "Danger",
        "danger",
        "https://raw.githubusercontent.com/danger/danger.systems/master/plugins-search-generated.json",
        "https://github.com/danger/danger-plugin-template"
      )

    require "danger/commands/plugins/plugin_lint"
    require "danger/commands/plugins/plugin_json"
    require "danger/commands/plugins/plugin_readme"

```

## Usage

##### List installed plugins

    $ [your tool] plugins installed

List all installed plugins with their respective version 

##### List known plugins

    $ [your tool] plugins list

List all known plugins (according to the list hosted on `http://github.com/CocoaPods/cocoapods-plugins`)

##### Search plugins

    $ [your tool] plugins search QUERY

Search plugins whose name contains the given text (ignoring case). With --full, it searches by name but also by author and description.

##### Create a new plugin

    $ [your tool] plugins create NAME [TEMPLATE_URL]

Create a scaffold for the development of a new plugin according to the your tool's best practices.

If a `TEMPLATE_URL`, pointing to a git repo containing a compatible template, is specified, it will be used in place of the default one.

## Get your plugin listed

    $ [your tool] plugins publish

Create an issue in the plugins search GitHub repository to ask for your plugin to be added to the official list (with the proper JSON fragment to be added to `plugins.json` so we just have to copy/paste it).
