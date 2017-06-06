module MediaAttributesImport
  class Seed
    def initialize
      @init_attributes = %w[Pacing Complexity Tone]
    end

    def associate_anime(attribute)
      anime = []
      Anime.all.each do |a|
        anime << { anime: a, media_attribute: attribute}
      end
      
      begin
       AnimeMediaAttribute.create!(anime)
      rescue
      end
    end

    def associate_drama(attribute)
      dramas = []
      Drama.all.each do |drama|
        dramas << {drama: drama, media_attribute: attribute}
      end

      begin
        DramasMediaAttribute.create!(dramas)
      rescue
      end
    end

    def associate_manga(attribute)
      manga = []
      Manga.all.each do |m|
        manga << { manga: m, media_attribute: attribute }
      end
      

      begin
        MangaMediaAttribute.create!(manga)
      rescue
      end
    end

    def create_attributes!
      @init_attributes.each do |attribute|
        media_attribute = MediaAttribute.where(
          title: attribute.titleize
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