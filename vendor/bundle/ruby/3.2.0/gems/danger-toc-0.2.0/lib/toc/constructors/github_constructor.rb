module Danger
  module Toc
    module Constructors
      class GithubConstructor < KramdownConstructor
        PUNCTUATION_REGEXP = /[^\p{Word}\- ]/u

        def basic_generate_id(str)
          # Get source code from https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/toc_filter.rb#L38
          id = str.downcase
          id.gsub!(PUNCTUATION_REGEXP, '') # remove punctuation
          id.tr!(' ', '-') # replace spaces with dash
          id
        end
      end
    end
  end
end
