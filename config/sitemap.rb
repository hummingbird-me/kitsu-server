unless Rails.env.development?
  adapter = SitemapGenerator::AwsSdkAdapter.new('kitsu-media')
  SitemapGenerator::Sitemap.adapter = adapter
end
SitemapGenerator::Sitemap.default_host = 'https://kitsu.io'
SitemapGenerator::Sitemap.create do
  [Anime, Manga, Drama].each do |model|
    resource = model.table_name
    group(filename: resource) do
      model.find_each do |row|
        add "/#{resource}/#{row.slug}", lastmod: row.updated_at, images: [
          {
            loc: row.cover_image.to_s,
            caption: "#{row.canonical_title} Banner"
          },
          {
            loc: row.poster_image.to_s,
            caption: "#{row.canonical_title} Poster"
          }
        ]
      end
    end
  end
  group(filename: 'users') do
    User.find_each do |user|
      add "/users/#{user.name}", lastmod: user.updated_at, images: [
        { loc: user.avatar.to_s, caption: "#{user.name} Avatar" },
        { loc: user.cover_image.to_s, caption: "#{user.name} Banner" }
      ]
    end
  end
end
