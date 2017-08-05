module HTML
  class Pipeline
    class HashtagsFilter < Filter
      # These regexex are reproduced from the twitter/tweet-text library, which is licensed under
      # the Apache 2.0 license.  The originals can be found at the following URL:
      #
      # https://github.com/twitter/twitter-text/blob/master/java/src/com/twitter/Regex.java

      # For these, we don't worry about the *exact* details of the character classes, so we just use
      # \p{} groups directly.  Ruby 2.3, in fact, has nearly-perfect sets for these.  For more
      # information about the complexities and nuances of using \p{} groups across platforms,
      # Twitter has kindly documented that here:
      #
      # https://github.com/twitter/twitter-text/blob/master/unicode_regex/README
      HASHTAG_LETTERS_AND_MARKS = '\p{L}\p{M}'.freeze
      HASHTAG_NUMERALS = '\p{Nd}'.freeze
      HASHTAG_SPECIAL_CHARS = (
        '_' +      # underscore
        '\u200c' + # ZERO WIDTH NON-JOINER
        '\u200d' + # ZERO WIDTH JOINER
        '\ua67e' + # CYRILLIC KAVYKA
        '\u05be' + # HEBREW PUNCTUATION MAQAF
        '\u05f3' + # HEBREW PUNCTUATION GERESH
        '\u05f4' + # HEBREW PUNCTUATION GERSHAYIM
        '\uff5e' + # FULLWIDTH TILDE
        '\u301c' + # WAVE DASH
        '\u309b' + # KATAKANA-HIRAGANA VOICED SOUND MARK
        '\u309c' + # KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK
        '\u30a0' + # KATAKANA-HIRAGANA DOUBLE HYPHEN
        '\u30fb' + # KATAKANA MIDDLE DOT
        '\u3003' + # DITTO MARK
        '\u0f0b' + # TIBETAN MARK INTERSYLLABIC TSHEG
        '\u0f0c' + # TIBETAN MARK DELIMITER TSHEG BSTAR
        '\u00b7'   # MIDDLE DOT
      ).freeze
      HASHTAG_LETTERS_NUMERALS = HASHTAG_LETTERS_AND_MARKS +
                                 HASHTAG_NUMERALS +
                                 HASHTAG_SPECIAL_CHARS
      HASHTAG_LETTERS_SET = "[#{HASHTAG_LETTERS_AND_MARKS}]".freeze
      HASHTAG_LETTERS_NUMERALS_SET = "[#{HASHTAG_LETTERS_NUMERALS}]".freeze

      VALID_HASHTAG = /(^|\uFE0E|[^&#{HASHTAG_LETTERS_NUMERALS}])(#|\uFF03)(?!\uFE0F|\u20E3)(#{HASHTAG_LETTERS_NUMERALS_SET}*#{HASHTAG_LETTERS_SET}#{HASHTAG_LETTERS_NUMERALS_SET}*)/i # rubocop:disable Metrics/LineLength

      def call
        result[:hashtags] ||= []
        doc.xpath('./text()').each do |node|
          # Skip if we're inside a link
          next unless node.ancestors('a').empty?
          # Otherwise linkify hashtags
          new_text = node.text.gsub(VALID_HASHTAG) do
            # rubocop:disable Style/PerlBackrefs
            text = [$2, $3].join
            result[:hashtags] << $3
            "#{Sanitize.fragment($1)}#{link_for($3, text)}"
            # rubocop:enable Style/PerlBackrefs
          end
          node.swap(new_text)
        end
        doc
      end

      private

      def link_for(hashtag, text)
        hashtag = Sanitize.fragment(hashtag)
        text = Sanitize.fragment(text)
        href = href_for(hashtag)
        "<a href=\"#{href}\" title=\"##{hashtag}\" class=\"hashtag\">#{text}</a>"
      end

      def href_for(hashtag)
        "https://kitsu.io/posts?query=%23#{hashtag}"
      end
    end
  end
end
