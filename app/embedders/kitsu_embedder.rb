class KitsuEmbedder < Embedder
  KITSU_URL = %r{\Ahttps?://(?:www\.|staging\.)?kitsu.io/(?<type>[^/]+)/(?<id>[^/]+).*}

  def match?
    KITSU_URL.match(url).present? && subject
  end

  def to_h
    {
      kind: "link.kitsu.#{type.singularize}",
      url: url,
      title: title,
      description: description,
      image: image,
      site: { name: 'Kitsu' },
      kitsu: {
        type: type.singularize,
        id: subject&.id
      }.compact
    }
  end

  private

  def type
    KITSU_URL.match(url)['type']
  end

  def id
    KITSU_URL.match(url)['id']
  end

  def subject
    case type
    when 'users' then User.by_slug(id).first || User.find_by(id: id)
    when 'anime' then Anime.by_slug(id).first || Anime.find_by(id: id)
    when 'manga' then Manga.by_slug(id).first || Manga.find_by(id: id)
    when 'drama' then Drama.by_slug(id).first || Drama.find_by(id: id)
    when 'posts' then Post.find_by(id: id)
    when 'comments' then Comment.find_by(id: id)
    end
  end

  def title
    case subject
    when User then subject.name
    when Titleable then subject.canonical_title
    when Post then "Post by #{subject.user.name}"
    when Comment then "#{subject.user.name}'s Comment on #{subject.post.user.name}'s Post"
    end
  end

  def description
    case subject
    when User then subject.about
    when Media then subject.synopsis
    when Post, Comment then subject.content
    end
  end

  def image
    case subject
    when User then subject.avatar.url(:medium)
    when Media then subject.poster_image.url(:medium)
    when Post, Comment then subject.user.avatar.url(:medium)
    end
  end

  def canonical_url
    "https://kitsu.io/#{type}/#{subject&.id || id}"
  end
end
