## Changelog

### 0.8.0 (2025/12/18)

* [#70](https://github.com/dblock/danger-changelog/pull/70): Workflow postreview improvments - [@numbata](https://github.com/numbata).
* [#68](https://github.com/dblock/danger-changelog/pull/68): Fix Danger comment workflow artifact download and script core injection - [@numbata](https://github.com/numbata).
* [#66](https://github.com/dblock/danger-changelog/pull/66): Update danger workflow with tokenless execution and two-workflow pattern - [@numbata](https://github.com/numbata).
* [#65](https://github.com/dblock/danger-changelog/pull/65): Add support for running changelog checks without GitHub API token - [@numbata](https://github.com/numbata).

### 0.7.1 (2024/04/12)

* [#63](https://github.com/dblock/danger-changelog/pull/63): Fix: report on lines that start with a - and cannot be parsed - [@dblock](https://github.com/dblock).
* [#64](https://github.com/dblock/danger-changelog/pull/64): Upgraded to RuboCop 1.63.1 - [@dblock](https://github.com/dblock).

### 0.7.0 (2023/11/21)

* [#62](https://github.com/dblock/danger-changelog/pull/62): Migrate CI from Travis to GitHub Actions - [@mathroule](https://github.com/mathroule).
* [#61](https://github.com/dblock/danger-changelog/pull/61): Add support for ISO date & time - [@mathroule](https://github.com/mathroule).

### 0.6.1 (2020/05/08)

* [#33](https://github.com/dblock/danger-changelog/issues/33): Attempt to point out known problems in Intridea format - [@dblock](https://github.com/dblock).
* [#51](https://github.com/dblock/danger-changelog/pull/51): Allow markdown links in keep-a-changelog lines - [@dblock](https://github.com/dblock).
* [#50](https://github.com/dblock/danger-changelog/pull/50): Added TOC to README - [@dblock](https://github.com/dblock).

### 0.6.0 (2019/07/28)

* [#47](https://github.com/dblock/danger-changelog/pull/47): Configure `Config#placeholder_line` at plugin level - [@dblock](https://github.com/dblock).
* [#47](https://github.com/dblock/danger-changelog/pull/47): Deprecate `Danger::Changelog.configure` - [@dblock](https://github.com/dblock).
* [#48](https://github.com/dblock/danger-changelog/pull/48): Deprecate `check` in favor of `check!` and configure `format` separately - [@dblock](https://github.com/dblock).
* [#49](https://github.com/dblock/danger-changelog/pull/48): Added `Config#ignore_files` with filename and regex support - [@dblock](https://github.com/dblock).

### 0.5.0 (2019/05/31)

* [#41](https://github.com/dblock/danger-changelog/pull/41): Document what's a correctly-formatted CHANGELOG - [@ivoanjo](https://github.com/ivoanjo).
* [#44](https://github.com/dblock/danger-changelog/pull/44): Add support for the [Keep a Changelog](https://keepachangelog.com) format for the change log - [@michaelherold](https://github.com/michaelherold).

### 0.4.2 (2018/12/21)

* [#37](https://github.com/dblock/danger-changelog/issues/37): Allow for parenthesis and brackets around headers - [@dblock](https://github.com/dblock).

### 0.4.1 (2018/12/20)

* [#37](https://github.com/dblock/danger-changelog/issues/37): Allow for parenthesis and brackets around versions and dates - [@dblock](https://github.com/dblock).
* [#38](https://github.com/dblock/danger-changelog/pull/38): Check for imbalanced parenthesis and brackets - [@dblock](https://github.com/dblock).

### 0.4.0 (2018/12/16)

* [#35](https://github.com/dblock/danger-changelog/pull/35): Check that dates in headers are ISO8601 - [@dblock](https://github.com/dblock).
* [#36](https://github.com/dblock/danger-changelog/pull/36): Check the format of the version number - [@dblock](https://github.com/dblock).

### 0.3.0 (2018/5/17)

* [#25](https://github.com/dblock/danger-changelog/pull/25): Add information how to configure the plugin in README.md - [@antondomashnev](https://github.com/antondomashnev).
* [#24](https://github.com/dblock/danger-changelog/pull/24): Added support for custom '* Your contribution here.' line - [@antondomashnev](https://github.com/antondomashnev).
* [#31](https://github.com/dblock/danger-changelog/pull/31): Stop checking for placeholder line when `Danger::Changelog.config.placeholder_line` is set to `nil` - [@dblock](https://github.com/dblock).
* [#28](https://github.com/dblock/danger-changelog/issues/28): Improve wording suggesting that CHANGELOG should be updated unless one is improving documentation - [@dblock](https://github.com/dblock).

### 0.2.1 (2016/12/04)

* [#17](https://github.com/dblock/danger-changelog/pull/17): Fix: handle CHANGELOG lines that mistakenly start with a symbol other than * - [@antondomashnev](https://github.com/antondomashnev).
* [#19](https://github.com/dblock/danger-changelog/pull/19): Added: RELEASING.md document to formalize the process - [@antondomashnev](https://github.com/antondomashnev).
* [#20](https://github.com/dblock/danger-changelog/pull/20): Fix: flag extra period and column in CHANGELOG - [@antondomashnev](https://github.com/antondomashnev).

### 0.2.0 (2016/11/21)

* [#13](https://github.com/dblock/danger-changelog/pull/13): Fix: suggested CHANGELOG entry may not be of correct format - [@dblock](https://github.com/dblock).
* [#18](https://github.com/dblock/danger-changelog/pull/18): Fix: incorrect CHANGELOG filename reported when file doesn't exist - [@dblock](https://github.com/dblock).

### 0.1.0 (2016/8/26)

* [#2](https://github.com/dblock/danger-changelog/pull/2): Added `is_changelog_format_correct?` - [@dblock](https://github.com/dblock).
* [#1](https://github.com/dblock/danger-changelog/pull/1): Added `have_you_updated_changelog?`, have you updated CHANGELOG.md? - [@dblock](https://github.com/dblock).
