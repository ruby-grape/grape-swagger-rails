# Contributing

Contribution to mime-types-data is encouraged in any form: a bug report, new
MIME type definitions, or additional code to help manage the MIME types. New
features should be proposed and discussed in an [issue][issues].

Before contributing patches, please read the [Licence](./LICENCE.md).

MIME::Types data is governed under the
[Contributor Covenant Code of Conduct][cccoc].

## Code Guidelines

I have several guidelines to contributing code through pull requests:

- I use code formatters, static analysis tools, and linting to ensure consistent
  styles and formatting. There should be no warning output from test run
  processes. I use [Standard Ruby][standardrb].

- Proposed changes should be on a thoughtfully-named topic branch and organized
  into logical commit chunks as appropriate.

- Use [Conventional Commits][conventional] with my
  [conventions](#commit-conventions).

- Versions must not be updated in pull requests unless otherwise directed. This
  means that you must not:

  - Modify `VERSION` in `lib/mime/types/data.rb`. When your patch is accepted
    and a release is made, the version will be updated at that point.

  - Modify `mime-types-data.gemspec`; it is a generated file. (You _may_ use
    `rake gemspec` to regenerate it if your change involves metadata related to
    gem itself).

  - Modify the `Gemfile`.

- Type updates may only be performed on the YAML files in `types/`. This means
  that no files may be modified in `data/`. Any changes to be captured here will
  be automatically updated on the next release.

- Documentation should be added or updated as appropriate for new or updated
  functionality. The documentation is RDoc; mime-types-data does not use
  extensions that may be present in alternative documentation generators.

- All GitHub Actions checks marked as required must pass before a pull request
  may be accepted and merged.

- Add your name or GitHub handle to `CONTRIBUTORS.md` and a record in the
  `CHANGELOG.md` as a separate commit from your main change. (Follow the style
  in the `CHANGELOG.md` and provide a link to your PR.)

- Include your DCO sign-off in each commit message (see [LICENCE](LICENCE.md)).

Although mime-types-data was extracted from the [Ruby mime-types][rmt] gem and
the support files are written in Ruby, the _target_ of mime-types-data is any
implementation that wishes to use the data as a MIME types registry, so I am
particularly interested in tools that will create a mime-types-data package for
other languages.

## Adding or Modifying MIME Types

The Ruby mime-types gem loads its data from files encoded in the `data`
directory in this gem by loading `mime-types-data` and reading
MIME::Types::Data::PATH. These files are compiled files from the collection of
data in the `types` directory.

> [!WARNING]
>
> Pull requests that include changes to files in `data/` will require amendment
> to revert these files.

New or modified MIME types should be edited in the appropriate YAML file under
`types`. The format is as shown below for the `application/xml` MIME type in
`types/application.yml`.

```yaml
- !ruby/object:MIME::Type
  content-type: application/xml
  encoding: 8bit
  extensions:
    - xml
    - xsl
  references:
    - IANA
    - RFC3023
  xrefs:
    rfc:
      - rfc3023
  registered: true
```

There are other fields that can be added, matching the fields discussed in the
documentation for MIME::Type. Pull requests for MIME types should just contain
the changes to the YAML files for the new or modified MIME types; I will convert
the YAML files to JSON prior to a new release. I would rather not have to verify
that the JSON matches the YAML changes, which is why it is not necessary to run
conversion for the pull request.

If you are making a change for a private fork, use `rake convert:yaml:json` to
convert the YAML to JSON and `rake convert:yaml:columnar` to convert it to the
default columnar format.

### Updating Types from the IANA or Apache Lists

If you are maintaining a private fork and wish to update your copy of the MIME
types registry used by this gem, you can do this with the rake tasks:

```sh
$ rake mime:iana
$ rake mime:apache
```

#### A Note on Provisional Types

Provisionally registered types from IANA are contained in the `types/*.yaml`
files. Per IANA,

> This registry, unlike some other provisional IANA registries, is only for
> temporary use. Entries in this registry are either finalized and moved to the
> main media types registry or are abandoned and deleted. Entries in this
> registry are suitable for use for development and test purposes only.

Provisional types are rewritten when updated, so pull requests to manually
customize provisional types (such as with extensions) are considered lower
priority. It is recommended that any updates required to the data be performed
in your application if you require provisional types.

## Commit Conventions

MIMe::Types has adopted a variation of the Conventional Commits format for
commit messages. The following types are permitted:

| Type    | Purpose                                               |
| ------- | ----------------------------------------------------- |
| `feat`  | A new feature                                         |
| `fix`   | A bug fix                                             |
| `chore` | A code change that is neither a bug fix nor a feature |
| `docs`  | Documentation updates                                 |
| `deps`  | Dependency updates, including GitHub Actions.         |
| `types` | Manually contributed MIME::Types                      |

I encourage the use of [Tim Pope's][tpope-qcm] or [Chris Beam's][cbeams]
guidelines on the writing of commit messages

I require the use of [git][trailers1] [trailers][trailers2] for specific
additional metadata and strongly encourage it for others. The conditionally
required metadata trailers are:

- `Breaking-Change`: if the change is a breaking change. **Do not** use the
  shorthand form (`feat!(scope)`) or `BREAKING CHANGE`.

- `Signed-off-by`: this is required for all developers except me, as outlined in
  the [Licence](./LICENCE.md#developer-certificate-of-origin).

- `Fixes` or `Resolves`: If a change fixes one or more open [issues][issues],
  that issue must be included in the `Fixes` or `Resolves` trailer. Multiple
  issues should be listed comma separated in the same trailer:
  `Fixes: #1, #5, #7`, but _may_ appear in separate trailers. While both `Fixes`
  and `Resolves` are synonyms, only _one_ should be used in a given commit or
  pull request.

- `Related to`: If a change does not fix an issue, those issue references should
  be included in this trailer.

## The Release Process

The release process is completely automated, where upstream MIME types will be
updated weekly (on Tuesdays) and be presented in a reviewable pull request. Once
merged, the release will be automatically published to RubyGems.

With the addition of [trusted publishing][tp], there should no longer be a need
for manual releases outside of the update cycle. Pull requests merged between
cycles will be released on the next cycle.

If it becomes necessary to perform a manual release, IANA updates should be
performed manually.

1. Review any outstanding issues or pull requests to see if anything needs to be
   addressed. This is necessary because there is no automated source for
   extensions for the thousands of MIME entries. (Suggestions and/or pull
   requests for same would be deeply appreciated.)
2. `bundle install`
3. Review the changes to make sure that the changes are sane. The IANA data
   source changes from time to time, resulting in big changes or even a broken
   step 4. (The most recent change was the addition of the `font/*` top-level
   category.)
4. Write up the changes in `CHANGELOG.md`. If any PRs have been merged, these
   should be noted specifically and contributions should be added in
   `Contributing.md`.
5. Ensure that the `VERSION` in `lib/mime/types/data.rb` is updated with the
   current date UTC.
6. Run `rake gemspec` to ensure that `mime-types.gemspec` has been updated.
7. Commit the changes and push to GitHub. The automated trusted publishing
   workflow will pick up the changes.

This list is based on issue [#18][issue-18].

[cbeams]: https://cbea.ms/git-commit/
[cccoc]: ./CODE_OF_CONDUCT.md
[conventional]: https://www.conventionalcommits.org/en/v1.0.0/
[dco]: licences/dco.txt
[hoe]: https://github.com/seattlerb/hoe
[issue-18]: https://github.com/mime-types/mime-types-data/issues/18
[issues]: https://github.com/mime-types/mime-types-data/issues
[minitest]: https://github.com/seattlerb/minitest
[release-gem]: https://github.com/rubygems/release-gem
[rmt]: https://github.com/mime-types/ruby-mime-types/
[standardrb]: https://github.com/standardrb/standard
[tp]: https://guides.rubygems.org/trusted-publishing/
[tpope-qcm]: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[trailers1]: https://git-scm.com/docs/git-interpret-trailers
[trailers2]: https://git-scm.com/docs/git-commit#Documentation/git-commit.txt---trailerlttokengtltvaluegt
