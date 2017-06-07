module MediaAttributesImport
  class Seed
    def initialize
      @init_attributes = %w[Pacing Complexity Tone]
      @init_attributes_titles = {
        'Pacing' => {
          'low' => 'Slow',
          'neutral' => 'Neutral',
          'high' => 'Fast'
        },
        'Complexity' => {
          'low' => 'Simple',
          'neutral' => 'Neutral',
          'high' => 'Complex'
        },
        'Tone' => {
          'low' => 'Light',
          'neutral' => 'Neutral',
          'high' => 'Dark'
        }
      }
    end

    def associate_anime(attribute)
      anime = []
      Anime.all.each do |a|
        anime << { anime: a, media_attribute: attribute }
      end

      begin
        AnimeMediaAttribute.create!(anime)
      rescue ActiveRecord::RecordNotUnique => rnu
        handle_record_not_unique(rnu)
      end
    end

    def associate_drama(attribute)
      dramas = []
      Drama.all.each do |drama|
        dramas << { drama: drama, media_attribute: attribute }
      end

      begin
        DramasMediaAttribute.create!(dramas)
      rescue ActiveRecord::RecordNotUnique => rnu
        handle_record_not_unique(rnu)
      end
    end

    def associate_manga(attribute)
      manga = []
      Manga.all.each do |m|
        manga << { manga: m, media_attribute: attribute }
      end

      begin
        MangaMediaAttribute.create!(manga)
      rescue ActiveRecord::RecordNotUnique => rnu
        handle_record_not_unique(rnu)
      end
    end

    def handle_record_not_unique(rec) end

    def create_attributes!
      @init_attributes.each do |attribute|
        media_attribute = MediaAttribute.where(
          title: attribute.titleize,
          low_title: @init_attributes_titles[attribute]['low'].titleize,
          neutral_title: @init_attributes_titles[attribute]['neutral'].titleize,
          high_title: @init_attributes_titles[attribute]['high'].titleize
        ).first_or_create
        associate_anime(media_attribute)
        associate_drama(media_attribute)
        associate_manga(media_attribute)
      end
    end

    def run!
      ActiveRecord::Base.logger = Logger.new(nil)
      Chewy.strategy(:bypass)
      create_attributes!
    end
  end
end
