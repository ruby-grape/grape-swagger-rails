# frozen_string_literal: true

require 'danger-pr-comment'
require 'English'

# Shared Dangerfile to export a JSON report for the danger-pr-comment workflows.
dangerfile_instance = self if defined?(Danger::Dangerfile) && is_a?(Danger::Dangerfile)
at_exit do
  # Only skip if there's an actual exception (not SystemExit from danger calling exit)
  next if $ERROR_INFO && !$ERROR_INFO.is_a?(SystemExit)
  next unless dangerfile_instance

  reporter = DangerPrComment::Reporter.new(dangerfile_instance.status_report)
  reporter.export_json(
    ENV.fetch('DANGER_REPORT_PATH', nil),
    ENV.fetch('GITHUB_EVENT_PATH', nil)
  )
end
