namespace :attachments do
  desc 'Resave all paperclip attachments'
  task resave: :environment do
    ActiveRecord::Base.logger = Logger.new(nil)
    Chewy.strategy(:bypass)

    # Poster Images and Covers for Media
    Anime.where.not('poster_image_file_size IS NULL').find_each do |anime|
      anime.update(poster_image: anime.poster_image)
    end
    Anime.where.not('cover_image_file_size IS NULL').find_each do |anime|
      anime.update(cover_image: anime.cover_image)
    end

    Drama.where.not('poster_image_file_size IS NULL').find_each do |drama|
      drama.update(poster_image: drama.poster_image)
    end
    Drama.where.not('cover_image_file_size IS NULL').find_each do |drama|
      drama.update(cover_image: drama.cover_image)
    end

    Manga.where.not('poster_image_file_size IS NULL').find_each do |manga|
      manga.update(poster_image: manga.poster_image)
    end
    Manga.where.not('cover_image_file_size IS NULL').find_each do |manga|
      manga.update(cover_image: manga.cover_image)
    end

    # Avatar Images and Covers for Users/Groups
    User.where.not('avatar_file_size IS NULL').find_each do |user|
      user.update(avatar: user.avatar)
    end
    User.where.not('cover_image_file_size IS NULL').find_each do |user|
      user.update(cover_image: user.cover_image)
    end

    Group.where.not('avatar_file_size IS NULL').find_each do |group|
      group.update(avatar: group.avatar)
    end
    Group.where.not('cover_image_file_size IS NULL').find_each do |group|
      group.update(cover_image: group.cover_image)
    end

    # Thumbnails for Episodes/Chapters
    Episode.where.not('thumbnail_size IS NULL').find_each do |episode|
      episode.update(upload: episode.content)
    end
    Chapter.where.not('thumbnail_size IS NULL').find_each do |chapter|
      chapter.update(thumbnail: chapter.thumbnail)
    end

    # Conntent For Uploads
    Upload.where.not('content_file_size IS NULL').find_each do |upload|
      upload.update(content: upload.content)
    end
  end
end
