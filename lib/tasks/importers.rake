namespace :importers do
  namespace :media_attributes do
    require 'media_attributes_import/seed_attributes'
    desc 'Create Initial Attributes and Associate with Media'
    task seed: :environment do |_t|
      puts 'Create Initial Attributes and Associate with Media'
      MediaAttributesImport::Seed.new.run!
    end
  end
  namespace :anidb do
    require 'anidb_category_import/category_importer'
    require 'anidb_category_import/media_importer'
    desc 'Import Categories'
    task categories: :environment do |_t|
      puts 'Importing Categories from AniDB dump'
      CategoryImporter.new.run!
    end
    desc 'Import Media Associated Categories'
    task media_assoc: :environment do |_t|
      puts 'Importing Associated Categories from AniDB/Kitsu Genre Mapping'
      MediaImporter.new.run!
    end
  end
  namespace :kitsu do
    desc 'Download only anime posters'
    task :posters, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Grabbing anime posters\033[0m\n"
      get_anime_image(args.quantity, :poster_image)
    end

    desc 'Download only anime covers'
    task :covers, [:quantity] => [:environment] do |_t, args|
      args.with_defaults(quantity: 72)
      puts "\n\033[32m=> Grabbing anime covers\033[0m\n"
      get_anime_image(args.quantity, :cover_image)
    end

    def get_anime_image(quantity, type = :poster_image)
      require 'data_import/kitsu'

      Chewy.strategy(:bypass) do
        puts 'Getting unimported list...'
        ids = Anime.find_each.reject { |a|
          path = a.send(type).path
          File.exist?(path) if path
        }.map(&:id)
        puts "Found #{ids.count}! Prioritizing popular series and limiting..."
        ids = Anime.where(id: ids).order(user_count: :desc).limit(quantity)
                   .pluck(:id)
        puts "Importing #{ids.count}!"
        GC.start

        puts 'Downloading files...'
        data = DataImport::Kitsu.new(host: 'https://kitsu.io')
        i = 0
        data.download_posters(ids) do |a, poster|
          i += 1
          anime = Anime.find(a['id'])
          if anime.update_attributes(type => poster)
            puts "\033[32m#{i}: #{anime.canonical_title}: Saved\033[0m"
          else
            puts "\033[31m#{i}: #{anime.canonical_title}: Failed to save\033[0m"
          end
          poster.close
        end
        data.run
      end
    end
  end

  desc 'Import the bcmoe.json file from disk or (by default) off because.moe'
  task :bcmoe, [:filename] => [:environment] do |_t, args|
    # Load the JSON
    json_file = open(args[:filename] || 'http://because.moe/json/us').read
    bcmoe = JSON.parse(json_file).map(&:deep_symbolize_keys)

    # Create the streamers
    puts '=> Creating Streamers'
    sites = bcmoe['shows'].map { |x| x[:sites].keys }.flatten.uniq
    sites = sites.map do |site|
      puts site
      [site, Streamer.where(site_name: site.to_s.titleize).first_or_create]
    end
    sites = Hash[sites]

    # Load the data
    puts '=> Loading Data'
    Chewy.strategy(:atomic) do
      bcmoe['shows'].each do |show|
        result = Mapping.guess(Anime, show[:name])

        # Shit results?  Let humans handle it!
        if result.nil?
          next puts("      #{show[:name]} => #{show[:sites]}")
        end

        anime = result
        confidence = 5
        # Handle Spanish Hulu bullshit
        spanish = show[:name].include?('(Espa')
        dubs = spanish ? %w[es] : %w[ja]
        subs = spanish ? %w[es] : %w[en]

        # Output confidence and title mapping
        print((' ' * confidence) + ('*' * (5 - confidence)) + ' ')
        puts "#{show[:name]} => #{anime.canonical_title}"

        # Create StreamingLink for each site listed
        show[:sites].each do |site, url|
          StreamingLink.where(
            streamer: sites[site],
            url: url,
            media: anime
          ).dubbed(dubs).subbed(subs).first_or_create(dubs: dubs, subs: subs)
        end
      end
    end
  end
end
