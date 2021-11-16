class BackfillOriginForMedia < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def down
    Anime.in_batches.update_all(origin_languages: [], origin_countries: [])
    Manga.in_batches.update_all(origin_languages: [], origin_countries: [])
  end

  def up
    updated_at = Time.now
    Anime.in_batches(of: 500, load: true) do |list|
      Anime.transaction do
        list.each do |anime|
          origin_languages = origin_languages_for_media(
            title_keys: anime.titles.keys,
            original_locale: anime.original_locale,
            subtype: anime.subtype
          )
          origin_countries = origin_countries_for_media(
            original_locale: anime.original_locale,
            subtype: anime.subtype
          )
          next if origin_languages.blank? && origin_countries.blank?
          anime.update_columns(
            origin_languages: origin_languages,
            origin_countries: origin_countries,
            updated_at: updated_at
          )
        end
      end
    end

    Manga.in_batches(of: 500, load: true) do |list|
      Manga.transaction do
        list.each do |manga|
          origin_languages = origin_languages_for_media(
            title_keys: manga.titles.keys,
            original_locale: manga.original_locale,
            subtype: manga.subtype
          )
          origin_countries = origin_countries_for_media(
            original_locale: manga.original_locale,
            subtype: manga.subtype
          )
          next if origin_languages.blank? && origin_countries.blank?
          manga.update_columns(
            origin_languages: origin_languages,
            origin_countries: origin_countries,
            updated_at: updated_at
          )
        end
      end
    end
  end

  private

  def origin_languages_for_media(original_locale:, subtype:, title_keys:)
    languages = []
    # Languages from subtype
    languages << case subtype
      when 'manwha' then ISO_639.find('kor')
      when 'manhua' then ISO_639.find('chi')
      when 'oel' then ISO_639.find('eng')
    end
    # Languages from original_locale
    if original_locale.present?
      languages += original_locale.split(',').map(&:strip).map do |locale|
        case locale
        when /Korea/i then ISO_639.find('kor')
        when /Jan?pan/i then ISO_639.find('jpn')
        when /China/i, /Taiwan/i, /Hong Kong/i then ISO_639.find('chi')
        when /United States/i, /Australia/i then ISO_639.find('eng')
        when /Italy/i then ISO_639.find('ita')
        when /Spain/i, /Ecuador/i, /Mexico/i then ISO_639.find('spa')
        when /Indonesia/i then ISO_639.find('ind')
        when /Saudi Arabia/i then ISO_639.find('ara')
        when /Sweden/i then ISO_639.find('swe')
        when /Cameroon/i then ISO_639.find('fra')
        when /Finland/i then ISO_639.find('fin')
        when /Portugal/i, /Bra[sz]il/i then ISO_639.find('por')
        when /Vietnam/i then ISO_639.find('vie')
        when /Malaysia/i then ISO_639.find('msa')
        when /Philippines/i then ISO_639.find('tgl')
        when /Germany/i then ISO_639.find('deu')
        end
      end
    end
    # Languages from non-Japanese romanized titles
    languages << if title_keys.include?('en_jp') then ISO_639.find('jpn')
    elsif title_keys.include?('en_kr') then ISO_639.find('kor')
    elsif title_keys.include?('en_cn') then ISO_639.find('chi')
    end

    languages.compact.map(&:alpha2).uniq
  end

  def origin_countries_for_media(original_locale:, subtype:)
    countries = []
    # Countries from original_locale
    if original_locale.present?
      countries += original_locale.split(',').map(&:strip).map do |locale|
        case locale
        when 'North Korea' then IsoCountryCodes.find('PRK')
        when 'South Korea', 'Korea' then IsoCountryCodes.find('KOR')
        when 'Janpan' then IsoCountryCodes.find('JPN')
        when 'China (mainland)' then IsoCountryCodes.find('CHN')
        when 'Cananda' then IsoCountryCodes.find('CAN')
        when 'Vietnamese' then IsoCountryCodes.find('VNM')
        else IsoCountryCodes.search_by_name(locale).first
        end
      rescue IsoCountryCodes::UnknownCodeError
        nil
      end
    end
    # Countries from subtype (only manwha)
    countries << (subtype == 'manwha' ? IsoCountryCodes.find('KOR') : nil)

    countries.compact.map(&:alpha2).uniq
  end
end
