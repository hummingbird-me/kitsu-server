require 'update_in_batches'

class FillMangaAgeRatings < ActiveRecord::Migration
  using UpdateInBatches

  self.disable_ddl_transaction!

  def up
    # Sorted by severity of rating
    {
      'Kids'          => [:G, 'Kids'],
      'Harem'         => [:PG],
      'Gender Bender' => [:PG],
      'Romance'       => [:PG],
      'Yuri'          => [:PG],
      'Yaoi'          => [:PG],
      'Gore'          => [:R, 'Gore'],
      'Ecchi'         => [:R, 'Ecchi'],
      'Doujinshi'     => [:R],
      'Horror'        => [:R, 'Horror'],
      'Hentai'        => [:R18, 'Hentai']
    }.each do |genre, (rating, reason)|
      update_rating_for_genre(rating, genre, reason)
    end
  end

  def down
    Manga.all.update_in_batches(age_rating: nil, age_rating_guide: nil)
  end

  private
  def update_rating_for_genre(rating, genre, reason)
    say_with_time "Filling age_rating column for #{genre} stuff" do
      genre = Genre.find_by(name: genre)&.id
      rating = Manga.age_ratings[rating]
      return unless genre
      Manga.joins(:manga_genres).where('genres_manga.genre_id': genre)
        .update_in_batches(age_rating: rating, age_rating_guide: reason)
    end
  end
end
