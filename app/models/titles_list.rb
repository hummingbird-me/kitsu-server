# frozen_string_literal: true

# Encapsulates the title logic for a Media, making it much easier to work with.
class TitlesList
  # @param titles [{Symbol, String => String}] the titles in various locales
  # @param canonical_locale [Symbol, String] the key of the canonical title in the titles hash
  # @param original_locale [Symbol, String, nil] the key of the original title in the titles hash
  # @param romanized_locale [Symbol, String, nil] the key of the romanized title in the titles hash
  # @param alternatives [<String>] the list of alternative titles
  def initialize(
    titles:,
    canonical_locale:,
    original_locale: nil,
    romanized_locale: nil,
    alternatives: []
  )
    @titles = titles
    @canonical_locale = canonical_locale
    @original_locale = original_locale
    @romanized_locale = romanized_locale
    @alternatives = alternatives
  end

  # @return [{String => String}] the titles keyed by locale
  def localized
    @localized ||= @titles.transform_keys { |key| fix_locale_code(key) }
  end

  # @return [<String>] the list of alternative titles
  attr_reader :alternatives

  # @return [String] the key of the canonical title in the localized titles hash
  def canonical_locale
    fix_locale_code(@canonical_locale)
  end

  # @return [String, nil] the key of the romanized/romaji title in the localized titles hash
  def romanized_locale
    # HACK: not everything has romanized locale set. Until then, fall back to the same bodge from
    # the frontend.
    fix_locale_code([
      @romanized_locale,
      'en_cn',
      'en_kr',
      'en_jp'
    ].find { |key| @titles.key?(key) })
  end

  # @return [String, nil] the key of the original title of the media in the localized titles hash
  def original_locale
    # TODO: we should aim to resolve all cases where this is nil and then add a validation to ensure
    # it moving forward

    # ja_jp is the fallback case for now
    fix_locale_code(
      [@original_locale, 'ja_jp'].find { |key| @titles.key?(key) }
    )
  end

  # @return [String, nil] the key of the best-matching translated title of the media in the
  #   localized titles hash based on `I18n.fallbacks[I18n.locale]`
  def translated_locale
    fix_locale_code(I18n.fallbacks[I18n.locale].find { |locale| @titles.key?(locale.to_s) }&.to_s)
  end

  # Apply a title preference and get the first present title from it. Pass in an array of title
  # types based on the order you prefer them, first being highest priority. As long as you one of
  # the options is `:canonical` you can assume that this will not return nil, since there is always
  # a canonical title. In future, the `:original` and `:romanized` options will provide a similar
  # guarantee.
  #
  # @param preferences [<:canonical, :romanized, :original, :translated>] the preference list of
  #   titles to try
  # @return [String, nil] the first title in the preference list which is available
  def first_title_for(preferences)
    list = preferences & %i[canonical romanized original translated]
    list.each do |key|
      title = public_send(key)
      return title if title.present?
    end
  end

  # @return [String] the canonical title (whatever we judge to be the "common" title)
  def canonical
    localized[canonical_locale]
  end

  # @return [String, nil] the romanized/romaji/transliterated title
  def romanized
    localized[romanized_locale]
  end

  # @return [String, nil] the original title of the media
  def original
    localized[original_locale]
  end

  # @return [String, nil] the title of the media, translated into your current locale
  def translated
    localized[translated_locale]
  end

  private

  # HACK: we store with old shitty keys, so we need to convert them to the new ones for output
  def fix_locale_code(key)
    locale = key&.tr('_', '-')
    case locale
    when 'en-cn', 'en-ch' then 'en-t-zh'
    when 'en-kr', 'en-kn' then 'en-t-ko'
    when 'en-th' then 'en-t-th'
    when 'en-jp' then 'en-t-ja'
    else locale
    end
  end

  def available_locales
    @available_locales ||= PreferredLocale.new(available: localized.keys)
  end
end
