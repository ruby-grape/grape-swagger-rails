# Danger PR Comment

Reusable GitHub Actions workflows for running Danger and posting a PR comment from a JSON report.

## Usage

### Quick Install

From your repository root:

```bash
curl -fsSL https://raw.githubusercontent.com/numbata/danger-pr-comment/main/scripts/install-workflows.sh | bash
```

Use `--force` to overwrite existing workflow files. To target a specific directory:

```bash
curl -fsSL https://raw.githubusercontent.com/numbata/danger-pr-comment/main/scripts/install-workflows.sh | bash -s -- --root /path/to/repo
```

### Manual Setup

Create `.github/workflows/danger.yml` in your repository:

```yaml
name: Danger
on:
  pull_request:
    types: [opened, reopened, edited, synchronize]

jobs:
  danger:
    uses: numbata/danger-pr-comment/.github/workflows/danger-run.yml@main
    secrets: inherit
```

Create `.github/workflows/danger-comment.yml` in your repository:

```yaml
name: Danger Comment
on:
  workflow_run:
    workflows: [Danger]
    types: [completed]

jobs:
  comment:
    uses: numbata/danger-pr-comment/.github/workflows/danger-comment.yml@main
    secrets: inherit
```

## Requirements

- Your repository must run `bundle exec danger` successfully.
- Your Dangerfile must write a JSON report to `ENV['DANGER_REPORT_PATH']` (for example, via a custom `at_exit` hook or a shared Dangerfile).
- The `Danger Comment` workflow needs `actions: read` and `issues: write` permissions to download artifacts and post comments.

### Dangerfile report example

If you want a shared Dangerfile, add the gem and import it:

```ruby
# Gemfile
gem 'danger-pr-comment', require: false
```

```ruby
# Dangerfile
# Import danger-pr-comment for automatic danger report export
danger.import_dangerfile(gem: 'danger-pr-comment')
```

Or add this to your project's `Dangerfile` (or a shared Dangerfile) to emit the JSON report yourself:

```ruby
# Dangerfile
require 'json'
require 'English'

dangerfile_instance = self if defined?(Danger::Dangerfile) && is_a?(Danger::Dangerfile)
at_exit do
  next if $ERROR_INFO && !$ERROR_INFO.is_a?(SystemExit)
  next unless dangerfile_instance

  report_path = ENV.fetch('DANGER_REPORT_PATH', nil)
  event_path = ENV.fetch('GITHUB_EVENT_PATH', nil)
  next unless report_path && event_path && File.exist?(event_path)

  event = JSON.parse(File.read(event_path))
  pr_number = event.dig('pull_request', 'number')
  next unless pr_number

  to_messages = lambda do |items|
    Array(items).map { |item| item.respond_to?(:message) ? item.message : item.to_s }
  end

  report = {
    pr_number: pr_number,
    errors: to_messages.call(dangerfile_instance.status_report[:errors]),
    warnings: to_messages.call(dangerfile_instance.status_report[:warnings]),
    messages: to_messages.call(dangerfile_instance.status_report[:messages]),
    markdowns: to_messages.call(dangerfile_instance.status_report[:markdowns])
  }

  File.write(report_path, JSON.pretty_generate(report))
end
```

## Inputs

`danger-run.yml` inputs:

- `ruby-version`: Ruby version for `ruby/setup-ruby`. Leave empty to use `.ruby-version`/`.tool-versions`.
- `bundler-cache`: Enable Bundler caching (default `true`).
- `danger-args`: Arguments passed to `bundle exec danger` (default `dry_run`).
- `report-artifact-name`: Artifact name for the report (default `danger-report`).
- `report-file`: Report filename (default `danger-report.json`).

`danger-comment.yml` inputs:

- `report-artifact-name`: Artifact name to download (default `danger-report`).
- `report-file`: Report filename inside the artifact (default `danger-report.json`).
- `comment-title`: Heading for the PR comment (default `Danger Report`).
- `comment-marker`: Marker string used to update the comment (default `<!-- danger-report -->`).

## License

MIT License. See [LICENSE](LICENSE.txt) for details.
