module Danger
  # Check whether the TOC in .md file(s) has been updated.
  #
  # @example Run all checks on the default README.md.
  #
  #          toc.check!
  #
  # @example Customize files and remind the requester to update TOCs when necessary.
  #
  #          toc.files = ['README.md']
  #          toc.is_toc_correct?
  #
  # @see  dblock/danger-toc
  # @tags toc

  class DangerToc < Plugin
    extend Forwardable

    def_delegators Danger::Toc.config, *Danger::Toc::Config::DELEGATORS

    # Run all checks.
    # @return [void]
    def check!
      is_toc_correct?
    end

    # Run all checks.
    # @return [void]
    def check
      warn '[DEPRECATION] `check` is deprecated. Please use `check!` instead.'
      check!
    end

    # Has the README file been modified?
    # @return [boolean]
    def toc_changes?
      (git.modified_files & files).any? || (git.added_files & files).any?
    end

    # Is the TOC format correct?
    # @return [boolean]
    def is_toc_correct?
      files.all? do |filename|
        toc_file = Danger::Toc::MarkdownFile.new(filename)
        if !toc_file.exists?
          messaging.fail("The #{filename} file does not exist.", sticky: false)
          false
        elsif toc_file.good?
          true
        else
          markdown <<-MARKDOWN
Here's the expected TOC for #{filename}:

```markdown
# #{Danger::Toc.config.header}

#{toc_file.toc_from_headers.join("\n")}
```
          MARKDOWN
          if toc_file.has_toc?
            messaging.fail("The TOC found in #{filename} doesn't match the sections of the file.", sticky: false)
          else
            messaging.fail("The #{filename} file is missing a TOC.", sticky: false)
          end
          false
        end
      end
    end
  end
end
