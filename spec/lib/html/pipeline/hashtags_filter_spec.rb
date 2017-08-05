require 'rails_helper'
require 'html/pipeline/hashtags_filter'

# The following example specs are reproduced from the twitter/tweet-text library, which is licensed
# under the Apache 2.0 license.  They have been modified to be usable in RSpec and match our
# formatting, but are otherwise largely intact.  The original examples can be found at the following
# URL:
#
# https://github.com/twitter/twitter-text/blob/master/conformance/autolink.yml

# rubocop:disable Metrics/LineLength
# rubocop:disable Style/AsciiComments

RSpec.describe HTML::Pipeline::HashtagsFilter do
  def twitter_example(text:, expected:, hashtags: [])
    expected = Nokogiri::HTML.fragment(expected).to_s
    filter = described_class.new(text)
    expect(filter.call.to_s).to eq(expected)
    expect(filter.result[:hashtags]).to eq(hashtags)
  end

  it 'should autolink trailing hashtag' do
    twitter_example(
      text: 'text #hashtag',
      expected: 'text <a href="https://kitsu.io/posts?query=%23hashtag" title="#hashtag" class="hashtag">#hashtag</a>',
      hashtags: %w[hashtag]
    )
  end

  it 'should autolink alphanumeric hashtag (letter-number-letter)' do
    twitter_example(
      text: 'text #hash0tag',
      expected: 'text <a href="https://kitsu.io/posts?query=%23hash0tag" title="#hash0tag" class="hashtag">#hash0tag</a>',
      hashtags: %w[hash0tag]
    )
  end

  it 'should autolink alphanumeric hashtag (number-letter)' do
    twitter_example(
      text: 'text #1tag',
      expected: 'text <a href="https://kitsu.io/posts?query=%231tag" title="#1tag" class="hashtag">#1tag</a>',
      hashtags: %w[1tag]
    )
  end

  it 'should autolink hashtag with underscore' do
    twitter_example(
      text: 'text #hash_tag',
      expected: 'text <a href="https://kitsu.io/posts?query=%23hash_tag" title="#hash_tag" class="hashtag">#hash_tag</a>',
      hashtags: %w[hash_tag]
    )
  end

  it 'should not autolink all-numeric hashtags' do
    twitter_example(
      text: 'text #1234',
      expected: 'text #1234',
      hashtags: []
    )
  end

  it 'should not autolink hashtag preceded by a letter' do
    twitter_example(
      text: 'text#hashtag',
      expected: 'text#hashtag',
      hashtags: []
    )
  end

  it 'should not autolink hashtag that begins with \ufe0f (Emoji style hash sign)' do
    twitter_example(
      text: '#️hashtag',
      expected: '#️hashtag',
      hashtags: []
    )
  end

  it 'should not autolink hashtag that begins with \ufe0f (Keycap style hash sign)' do
    twitter_example(
      text: '#⃣hashtag',
      expected: '#⃣hashtag',
      hashtags: []
    )
  end

  it 'should autolink multiple hashtags' do
    twitter_example(
      text: 'text #hashtag1 #hashtag2',
      expected: 'text <a href="https://kitsu.io/posts?query=%23hashtag1" title="#hashtag1" class="hashtag">#hashtag1</a> <a href="https://kitsu.io/posts?query=%23hashtag2" title="#hashtag2" class="hashtag">#hashtag2</a>',
      hashtags: %w[hashtag1 hashtag2]
    )
  end

  it 'should autolink hashtag preceded by a period' do
    twitter_example(
      text: 'text.#hashtag',
      expected: 'text.<a href="https://kitsu.io/posts?query=%23hashtag" title="#hashtag" class="hashtag">#hashtag</a>',
      hashtags: %w[hashtag]
    )
  end

  it 'should not autolink hashtag preceded by &' do
    twitter_example(
      text: '&#nbsp;',
      expected: '&#nbsp;',
      hashtags: []
    )
  end

  it 'should autolink hashtag followed by ! (! not included)' do
    twitter_example(
      text: 'text #hashtag!',
      expected: 'text <a href="https://kitsu.io/posts?query=%23hashtag" title="#hashtag" class="hashtag">#hashtag</a>!',
      hashtags: %w[hashtag]
    )
  end

  it 'should autolink two hashtags separated by a slash' do
    twitter_example(
      text: 'text #dodge/#answer',
      expected: 'text <a href="https://kitsu.io/posts?query=%23dodge" title="#dodge" class="hashtag">#dodge</a>/<a href="https://kitsu.io/posts?query=%23answer" title="#answer" class="hashtag">#answer</a>',
      hashtags: %w[dodge answer]
    )
  end

  it 'should autolink hashtag before a slash' do
    twitter_example(
      text: 'text #dodge/answer',
      expected: 'text <a href="https://kitsu.io/posts?query=%23dodge" title="#dodge" class="hashtag">#dodge</a>/answer',
      hashtags: %w[dodge]
    )
  end

  it 'should autolink hashtag after a slash' do
    twitter_example(
      text: 'text dodge/#answer',
      expected: 'text dodge/<a href="https://kitsu.io/posts?query=%23answer" title="#answer" class="hashtag">#answer</a>',
      hashtags: %w[answer]
    )
  end

  it 'should autolink hashtag followed by Japanese' do
    twitter_example(
      text: 'text #hashtagの',
      expected: 'text <a href="https://kitsu.io/posts?query=%23hashtagの" title="#hashtagの" class="hashtag">#hashtagの</a>',
      hashtags: %w[hashtagの]
    )
  end

  it 'should autolink hashtag preceded by full-width space (U+3000)' do
    twitter_example(
      text: 'text　#hashtag',
      expected: 'text　<a href="https://kitsu.io/posts?query=%23hashtag" title="#hashtag" class="hashtag">#hashtag</a>',
      hashtags: %w[hashtag]
    )
  end

  it 'should autolink hashtag followed by full-width space (U+3000)' do
    twitter_example(
      text: '#hashtag　text',
      expected: '<a href="https://kitsu.io/posts?query=%23hashtag" title="#hashtag" class="hashtag">#hashtag</a>　text',
      hashtags: %w[hashtag]
    )
  end

  it 'should autolink hashtag with full-width hash (U+FF03)' do
    twitter_example(
      text: '＃hashtag',
      expected: '<a href="https://kitsu.io/posts?query=%23hashtag" title="#hashtag" class="hashtag">＃hashtag</a>',
      hashtags: %w[hashtag]
    )
  end

  it 'should autolink hashtag with accented character at the start' do
    twitter_example(
      text: '#éhashtag',
      expected: '<a href="https://kitsu.io/posts?query=%23éhashtag" title="#éhashtag" class="hashtag">#éhashtag</a>',
      hashtags: %w[éhashtag]
    )
  end

  it 'should autolink hashtag with accented character at the end' do
    twitter_example(
      text: '#hashtagé',
      expected: '<a href="https://kitsu.io/posts?query=%23hashtagé" title="#hashtagé" class="hashtag">#hashtagé</a>',
      hashtags: %w[hashtagé]
    )
  end

  it 'should autolink hashtag with accented character in the middle' do
    twitter_example(
      text: '#hashétag',
      expected: '<a href="https://kitsu.io/posts?query=%23hashétag" title="#hashétag" class="hashtag">#hashétag</a>',
      hashtags: %w[hashétag]
    )
  end

  it 'should autolink hashtags in Korean' do
    twitter_example(
      text: 'What is #트위터 anyway?',
      expected: 'What is <a href="https://kitsu.io/posts?query=%23트위터" title="#트위터" class="hashtag">#트위터</a> anyway?',
      hashtags: %w[트위터]
    )
  end

  it 'should autolink hashtags in Russian' do
    twitter_example(
      text: 'What is #ашок anyway?',
      expected: 'What is <a href="https://kitsu.io/posts?query=%23ашок" title="#ашок" class="hashtag">#ашок</a> anyway?',
      hashtags: %w[ашок]
    )
  end

  it 'should autolink a katakana hashtag preceded by a space and followed by a space' do
    twitter_example(
      text: 'カタカナ #カタカナ カタカナ',
      expected: 'カタカナ <a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a> カタカナ',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a space and followed by a bracket' do
    twitter_example(
      text: 'カタカナ #カタカナ」カタカナ',
      expected: 'カタカナ <a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a>」カタカナ',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a space and followed by a edge' do
    twitter_example(
      text: 'カタカナ #カタカナ',
      expected: 'カタカナ <a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a>',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a bracket and followed by a space' do
    twitter_example(
      text: 'カタカナ「#カタカナ カタカナ',
      expected: 'カタカナ「<a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a> カタカナ',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a bracket and followed by a bracket' do
    twitter_example(
      text: 'カタカナ「#カタカナ」カタカナ',
      expected: 'カタカナ「<a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a>」カタカナ',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a bracket and followed by a edge' do
    twitter_example(
      text: 'カタカナ「#カタカナ',
      expected: 'カタカナ「<a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a>',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a edge and followed by a space' do
    twitter_example(
      text: '#カタカナ カタカナ',
      expected: '<a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a> カタカナ',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a edge and followed by a bracket' do
    twitter_example(
      text: '#カタカナ」カタカナ',
      expected: '<a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a>」カタカナ',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag preceded by a edge and followed by a edge' do
    twitter_example(
      text: '#カタカナ',
      expected: '<a href="https://kitsu.io/posts?query=%23カタカナ" title="#カタカナ" class="hashtag">#カタカナ</a>',
      hashtags: %w[カタカナ]
    )
  end

  it 'should autolink a katakana hashtag with a voiced sounds mark followed by a space' do
    twitter_example(
      text: '#ﾊｯｼｭﾀｸﾞ　テスト',
      expected: '<a href="https://kitsu.io/posts?query=%23ﾊｯｼｭﾀｸﾞ" title="#ﾊｯｼｭﾀｸﾞ" class="hashtag">#ﾊｯｼｭﾀｸﾞ</a>　テスト',
      hashtags: %w[ﾊｯｼｭﾀｸﾞ]
    )
  end

  it 'should autolink a katakana hashtag with a voiced sounds mark followed by numbers' do
    twitter_example(
      text: '#ﾊｯｼｭﾀｸﾞ123',
      expected: '<a href="https://kitsu.io/posts?query=%23ﾊｯｼｭﾀｸﾞ123" title="#ﾊｯｼｭﾀｸﾞ123" class="hashtag">#ﾊｯｼｭﾀｸﾞ123</a>',
      hashtags: %w[ﾊｯｼｭﾀｸﾞ123]
    )
  end

  it 'should autolink a katakana hashtag with another voiced sounds mark' do
    twitter_example(
      text: '#ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ',
      expected: '<a href="https://kitsu.io/posts?query=%23ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ" title="#ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ" class="hashtag">#ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ</a>',
      hashtags: %w[ﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ]
    )
  end

  it 'should autolink a kanji hashtag preceded by a space and followed by a space' do
    twitter_example(
      text: '漢字 #漢字 漢字',
      expected: '漢字 <a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a> 漢字',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a space and followed by a bracket' do
    twitter_example(
      text: '漢字 #漢字」漢字',
      expected: '漢字 <a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a>」漢字',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a space and followed by a edge' do
    twitter_example(
      text: '漢字 #漢字',
      expected: '漢字 <a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a>',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a bracket and followed by a space' do
    twitter_example(
      text: '漢字「#漢字 漢字',
      expected: '漢字「<a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a> 漢字',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a bracket and followed by a bracket' do
    twitter_example(
      text: '漢字「#漢字」漢字',
      expected: '漢字「<a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a>」漢字',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a bracket and followed by a edge' do
    twitter_example(
      text: '漢字「#漢字',
      expected: '漢字「<a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a>',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a edge and followed by a space' do
    twitter_example(
      text: '#漢字 漢字',
      expected: '<a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a> 漢字',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a edge and followed by a bracket' do
    twitter_example(
      text: '#漢字」漢字',
      expected: '<a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a>」漢字',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by a edge and followed by a edge' do
    twitter_example(
      text: '#漢字',
      expected: '<a href="https://kitsu.io/posts?query=%23漢字" title="#漢字" class="hashtag">#漢字</a>',
      hashtags: %w[漢字]
    )
  end

  it 'should autolink a kanji hashtag preceded by an ideographic comma, followed by an ideographic period' do
    twitter_example(
      text: 'これは、＃大丈夫。',
      expected: 'これは、<a href="https://kitsu.io/posts?query=%23大丈夫" title="#大丈夫" class="hashtag">＃大丈夫</a>。',
      hashtags: %w[大丈夫]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a space and followed by a space' do
    twitter_example(
      text: 'ひらがな #ひらがな ひらがな',
      expected: 'ひらがな <a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a> ひらがな',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a space and followed by a bracket' do
    twitter_example(
      text: 'ひらがな #ひらがな」ひらがな',
      expected: 'ひらがな <a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a>」ひらがな',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a space and followed by a edge' do
    twitter_example(
      text: 'ひらがな #ひらがな',
      expected: 'ひらがな <a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a>',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a bracket and followed by a space' do
    twitter_example(
      text: 'ひらがな「#ひらがな ひらがな',
      expected: 'ひらがな「<a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a> ひらがな',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a bracket and followed by a bracket' do
    twitter_example(
      text: 'ひらがな「#ひらがな」ひらがな',
      expected: 'ひらがな「<a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a>」ひらがな',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a bracket and followed by a edge' do
    twitter_example(
      text: 'ひらがな「#ひらがな',
      expected: 'ひらがな「<a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a>',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a edge and followed by a space' do
    twitter_example(
      text: '#ひらがな ひらがな',
      expected: '<a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a> ひらがな',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a edge and followed by a bracket' do
    twitter_example(
      text: '#ひらがな」ひらがな',
      expected: '<a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a>」ひらがな',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a hiragana hashtag preceded by a edge and followed by a edge' do
    twitter_example(
      text: '#ひらがな',
      expected: '<a href="https://kitsu.io/posts?query=%23ひらがな" title="#ひらがな" class="hashtag">#ひらがな</a>',
      hashtags: %w[ひらがな]
    )
  end

  it 'should autolink a Kanji/Katakana mix hashtag' do
    twitter_example(
      text: '日本語ハッシュタグ #日本語ハッシュタグ',
      expected: '日本語ハッシュタグ <a href="https://kitsu.io/posts?query=%23日本語ハッシュタグ" title="#日本語ハッシュタグ" class="hashtag">#日本語ハッシュタグ</a>',
      hashtags: %w[日本語ハッシュタグ]
    )
  end

  it 'should not autolink a hashtag without a preceding space' do
    twitter_example(
      text: '日本語ハッシュタグ#日本語ハッシュタグ',
      expected: '日本語ハッシュタグ#日本語ハッシュタグ',
      hashtags: []
    )
  end

  it 'should not include a punctuation in a hashtag' do
    twitter_example(
      text: '#日本語ハッシュタグ。',
      expected: '<a href="https://kitsu.io/posts?query=%23日本語ハッシュタグ" title="#日本語ハッシュタグ" class="hashtag">#日本語ハッシュタグ</a>。',
      hashtags: %w[日本語ハッシュタグ]
    )
  end

  it 'should autolink a hashtag after a punctuation' do
    twitter_example(
      text: '日本語ハッシュタグ。#日本語ハッシュタグ',
      expected: '日本語ハッシュタグ。<a href="https://kitsu.io/posts?query=%23日本語ハッシュタグ" title="#日本語ハッシュタグ" class="hashtag">#日本語ハッシュタグ</a>',
      hashtags: %w[日本語ハッシュタグ]
    )
  end

  it 'should autolink a hashtag with chouon' do
    twitter_example(
      text: '長音ハッシュタグ。#サッカー',
      expected: '長音ハッシュタグ。<a href="https://kitsu.io/posts?query=%23サッカー" title="#サッカー" class="hashtag">#サッカー</a>',
      hashtags: %w[サッカー]
    )
  end

  it 'should autolink a hashtag with half-width chouon' do
    twitter_example(
      text: '長音ハッシュタグ。#ｻｯｶｰ',
      expected: '長音ハッシュタグ。<a href="https://kitsu.io/posts?query=%23ｻｯｶｰ" title="#ｻｯｶｰ" class="hashtag">#ｻｯｶｰ</a>',
      hashtags: %w[ｻｯｶｰ]
    )
  end

  it 'should autolink a hashtag with half-width # after full-width ！' do
    twitter_example(
      text: 'できましたよー！#日本語ハッシュタグ。',
      expected: 'できましたよー！<a href="https://kitsu.io/posts?query=%23日本語ハッシュタグ" title="#日本語ハッシュタグ" class="hashtag">#日本語ハッシュタグ</a>。',
      hashtags: %w[日本語ハッシュタグ]
    )
  end

  it 'should autolink a hashtag with full-width ＃ after full-width ！' do
    twitter_example(
      text: 'できましたよー！＃日本語ハッシュタグ。',
      expected: 'できましたよー！<a href="https://kitsu.io/posts?query=%23日本語ハッシュタグ" title="#日本語ハッシュタグ" class="hashtag">＃日本語ハッシュタグ</a>。',
      hashtags: %w[日本語ハッシュタグ]
    )
  end

  it 'should autolink a hashtag containing ideographic iteration mark' do
    twitter_example(
      text: '#云々',
      expected: '<a href="https://kitsu.io/posts?query=%23云々" title="#云々" class="hashtag">#云々</a>',
      hashtags: %w[云々]
    )
  end

  it 'should autolink multiple hashtags in multiple languages' do
    twitter_example(
      text: 'Hashtags in #中文, #日本語, #한국말, and #русский! Try it out!',
      expected: 'Hashtags in <a href="https://kitsu.io/posts?query=%23中文" title="#中文" class="hashtag">#中文</a>, <a href="https://kitsu.io/posts?query=%23日本語" title="#日本語" class="hashtag">#日本語</a>, <a href="https://kitsu.io/posts?query=%23한국말" title="#한국말" class="hashtag">#한국말</a>, and <a href="https://kitsu.io/posts?query=%23русский" title="#русский" class="hashtag">#русский</a>! Try it out!',
      hashtags: %w[中文 日本語 한국말 русский]
    )
  end

  it 'should autolink should allow for ş (U+015F) in a hashtag' do
    twitter_example(
      text: 'Here’s a test tweet for you: #Ateş #qrşt #ştu #ş',
      expected: 'Here’s a test tweet for you: <a href="https://kitsu.io/posts?query=%23Ateş" title="#Ateş" class="hashtag">#Ateş</a> <a href="https://kitsu.io/posts?query=%23qrşt" title="#qrşt" class="hashtag">#qrşt</a> <a href="https://kitsu.io/posts?query=%23ştu" title="#ştu" class="hashtag">#ştu</a> <a href="https://kitsu.io/posts?query=%23ş" title="#ş" class="hashtag">#ş</a>',
      hashtags: %w[Ateş qrşt ştu ş]
    )
  end

  it 'should autolink a hashtag with Latin extended character' do
    twitter_example(
      text: '#mûǁae',
      expected: '<a href="https://kitsu.io/posts?query=%23mûǁae" title="#mûǁae" class="hashtag">#mûǁae</a>',
      hashtags: %w[mûǁae]
    )
  end

  # Please be careful with changes to this test case - what looks like "á" is
  # really a + U+0301, and many editors will silently convert this to U+00E1.
  it 'should autolink hashtags with combining diacritics' do
    twitter_example(
      text: '#táim #hag̃ua',
      expected: '<a href="https://kitsu.io/posts?query=%23táim" title="#táim" class="hashtag">#táim</a> <a href="https://kitsu.io/posts?query=%23hag̃ua" title="#hag̃ua" class="hashtag">#hag̃ua</a>',
      hashtags: %w[táim hag̃ua]
    )
  end

  it 'should autolink Arabic hashtag' do
    twitter_example(
      text: 'Arabic hashtag: #فارسی #لس_آنجلس',
      expected: 'Arabic hashtag: <a href="https://kitsu.io/posts?query=%23فارسی" title="#فارسی" class="hashtag">#فارسی</a> <a href="https://kitsu.io/posts?query=%23لس_آنجلس" title="#لس_آنجلس" class="hashtag">#لس_آنجلس</a>',
      hashtags: %w[فارسی لس_آنجلس]
    )
  end

  it 'should autolink Thai hashtag' do
    twitter_example(
      text: 'Thai hashtag: #รายละเอียด',
      expected: 'Thai hashtag: <a href="https://kitsu.io/posts?query=%23รายละเอียด" title="#รายละเอียด" class="hashtag">#รายละเอียด</a>',
      hashtags: %w[รายละเอียด]
    )
  end
end
