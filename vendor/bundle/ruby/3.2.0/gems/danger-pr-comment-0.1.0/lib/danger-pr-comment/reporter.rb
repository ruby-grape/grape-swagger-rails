# frozen_string_literal: true

require 'json'

module DangerPrComment
  class Reporter
    def initialize(status_report)
      @status_report = status_report
    end

    def export_json(report_path, event_path)
      return unless report_path && event_path && File.exist?(event_path)

      event = JSON.parse(File.read(event_path))
      pr_number = event.dig('pull_request', 'number')
      return unless pr_number

      report = build_report(pr_number)
      File.write(report_path, JSON.pretty_generate(report))
    end

    private

    def build_report(pr_number)
      {
        pr_number: pr_number,
        errors: to_messages(@status_report[:errors]),
        warnings: to_messages(@status_report[:warnings]),
        messages: to_messages(@status_report[:messages]),
        markdowns: to_messages(@status_report[:markdowns])
      }
    end

    def to_messages(items)
      Array(items).map do |item|
        item.respond_to?(:message) ? item.message : item.to_s
      end
    end
  end
end
