class AddIndicesToProblems < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    # Index on age ratings
    add_index :anime, :age_rating,
      comment: 'Provide index-only counts by age rating filter',
      algorithm: :concurrently,
      if_not_exists: true
    add_index :manga, :age_rating,
      comment: 'Provide index-only counts by age rating filter',
      algorithm: :concurrently,
      if_not_exists: true
    add_index :dramas, :age_rating,
      comment: 'Provide index-only counts by age rating filter',
      algorithm: :concurrently,
      if_not_exists: true

    # Index on media id columns + id to avoid pkey scans
    add_index :library_entries, %i[anime_id id],
      comment: 'Prevent pkey scans on small limits',
      algorithm: :concurrently,
      where: 'anime_id IS NOT NULL',
      order: { id: 'asc nulls last' },
      if_not_exists: true
    add_index :library_entries, %i[manga_id id],
      comment: 'Prevent pkey scans on small limits',
      algorithm: :concurrently,
      where: 'manga_id IS NOT NULL',
      order: { id: 'asc nulls last' },
      if_not_exists: true
    add_index :library_entries, %i[drama_id id],
      comment: 'Prevent pkey scans on small limits',
      algorithm: :concurrently,
      where: 'drama_id IS NOT NULL',
      order: { id: 'asc nulls last' },
      if_not_exists: true

    # Index users by name for some reason (idk who is querying this but stop)
    add_index :users, 'lower(name), id',
      name: 'index_users_on_lower_name_and_id',
      comment: 'Unknown who is querying this, but it is painfully slow without this index',
      algorithm: :concurrently,
      order: { id: 'asc nulls last' },
      if_not_exists: true
  end
end
