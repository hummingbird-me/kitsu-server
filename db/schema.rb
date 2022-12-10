# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_12_04_041942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "ama_subscribers", id: :serial, force: :cascade do |t|
    t.integer "ama_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ama_id", "user_id"], name: "index_ama_subscribers_on_ama_id_and_user_id", unique: true
    t.index ["ama_id"], name: "index_ama_subscribers_on_ama_id"
    t.index ["user_id"], name: "index_ama_subscribers_on_user_id"
  end

  create_table "amas", id: :serial, force: :cascade do |t|
    t.integer "author_id", null: false
    t.integer "original_post_id", null: false
    t.integer "ama_subscribers_count", default: 0, null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["author_id"], name: "index_amas_on_author_id"
    t.index ["original_post_id"], name: "index_amas_on_original_post_id"
  end

  create_table "anime", id: :serial, force: :cascade do |t|
    t.citext "slug"
    t.integer "age_rating"
    t.integer "episode_count"
    t.integer "episode_length"
    t.string "youtube_video_id", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "average_rating", precision: 5, scale: 2
    t.integer "user_count", default: 0, null: false
    t.string "age_rating_guide", limit: 255
    t.integer "subtype", default: 1, null: false
    t.date "start_date"
    t.date "end_date"
    t.hstore "rating_frequencies", default: {}, null: false
    t.integer "cover_image_top_offset", default: 0, null: false
    t.hstore "titles", default: {}, null: false
    t.string "canonical_title", default: "en_jp", null: false
    t.string "abbreviated_titles", default: [], null: false, array: true
    t.integer "popularity_rank"
    t.integer "rating_rank"
    t.integer "favorites_count", default: 0, null: false
    t.boolean "cover_image_processing"
    t.string "tba"
    t.integer "episode_count_guess"
    t.integer "total_length"
    t.text "release_schedule"
    t.string "original_locale"
    t.jsonb "description", default: {}, null: false
    t.jsonb "poster_image_data"
    t.jsonb "cover_image_data"
    t.string "origin_languages", default: [], array: true
    t.string "origin_countries", default: [], array: true
    t.index ["age_rating"], name: "index_anime_on_age_rating", comment: "Provide index-only counts by age rating filter"
    t.index ["average_rating"], name: "anime_average_rating_idx"
    t.index ["average_rating"], name: "index_anime_on_wilson_ci", order: :desc
    t.index ["slug"], name: "index_anime_on_slug", unique: true
    t.index ["user_count"], name: "index_anime_on_user_count"
  end

  create_table "anime_castings", id: :serial, force: :cascade do |t|
    t.integer "anime_character_id", null: false
    t.integer "person_id", null: false
    t.string "locale", null: false
    t.integer "licensor_id"
    t.string "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["anime_character_id", "person_id", "locale"], name: "index_anime_castings_on_character_person_locale", unique: true
    t.index ["anime_character_id"], name: "index_anime_castings_on_anime_character_id"
    t.index ["person_id"], name: "index_anime_castings_on_person_id"
  end

  create_table "anime_characters", id: :serial, force: :cascade do |t|
    t.integer "anime_id", null: false
    t.integer "character_id", null: false
    t.integer "role", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["anime_id", "character_id"], name: "index_anime_characters_on_anime_id_and_character_id", unique: true
    t.index ["anime_id"], name: "index_anime_characters_on_anime_id"
    t.index ["character_id"], name: "index_anime_characters_on_character_id"
  end

  create_table "anime_genres", id: false, force: :cascade do |t|
    t.integer "anime_id", null: false
    t.integer "genre_id", null: false
    t.index ["anime_id"], name: "index_anime_genres_on_anime_id"
    t.index ["genre_id"], name: "index_anime_genres_on_genre_id"
  end

  create_table "anime_media_attributes", id: :serial, force: :cascade do |t|
    t.integer "anime_id", null: false
    t.integer "media_attribute_id", null: false
    t.integer "high_vote_count", default: 0, null: false
    t.integer "neutral_vote_count", default: 0, null: false
    t.integer "low_vote_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_id", "media_attribute_id"], name: "index_anime_media_attribute", unique: true
    t.index ["anime_id"], name: "index_anime_media_attributes_on_anime_id"
    t.index ["media_attribute_id"], name: "index_anime_media_attributes_on_media_attribute_id"
  end

  create_table "anime_productions", id: :serial, force: :cascade do |t|
    t.integer "anime_id", null: false
    t.integer "producer_id", null: false
    t.integer "role", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["anime_id"], name: "index_anime_productions_on_anime_id"
    t.index ["producer_id"], name: "index_anime_productions_on_producer_id"
  end

  create_table "anime_staff", id: :serial, force: :cascade do |t|
    t.integer "anime_id", null: false
    t.integer "person_id", null: false
    t.string "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["anime_id", "person_id"], name: "index_anime_staff_on_anime_id_and_person_id", unique: true
    t.index ["anime_id"], name: "index_anime_staff_on_anime_id"
    t.index ["person_id"], name: "index_anime_staff_on_person_id"
  end

  create_table "blocks", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "blocked_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.index ["user_id"], name: "index_blocks_on_user_id"
  end

  create_table "castings", id: :serial, force: :cascade do |t|
    t.integer "media_id", null: false
    t.integer "person_id"
    t.integer "character_id"
    t.string "role", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "voice_actor", default: false, null: false
    t.boolean "featured", default: false, null: false
    t.integer "order"
    t.string "language", limit: 255
    t.string "media_type", limit: 255, null: false
    t.index ["character_id"], name: "index_castings_on_character_id"
    t.index ["media_id", "media_type"], name: "index_castings_on_media_id_and_media_type"
    t.index ["person_id"], name: "index_castings_on_person_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.citext "slug", null: false
    t.integer "anidb_id"
    t.integer "parent_id"
    t.integer "total_media_count", default: 0, null: false
    t.boolean "nsfw", default: false, null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "child_count", default: 0, null: false
    t.jsonb "description", default: {}, null: false
    t.string "ancestry", collation: "POSIX"
    t.index ["ancestry"], name: "index_categories_on_ancestry", opclass: :text_pattern_ops
    t.index ["anidb_id"], name: "index_categories_on_anidb_id"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug"
  end

  create_table "categories_dramas", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "drama_id", null: false
  end

  create_table "category_favorites", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_category_favorites_on_category_id"
    t.index ["user_id"], name: "index_category_favorites_on_user_id"
  end

  create_table "chapters", id: :serial, force: :cascade do |t|
    t.integer "manga_id"
    t.hstore "titles", default: {}, null: false
    t.string "canonical_title"
    t.integer "number", null: false
    t.integer "volume_number"
    t.integer "length"
    t.date "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "filler"
    t.integer "volume_id"
    t.jsonb "description", default: {}, null: false
    t.jsonb "thumbnail_data"
    t.index ["manga_id"], name: "index_chapters_on_manga_id"
  end

  create_table "character_voices", id: :serial, force: :cascade do |t|
    t.integer "media_character_id", null: false
    t.integer "person_id", null: false
    t.string "locale", null: false
    t.integer "licensor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_character_id"], name: "index_character_voices_on_media_character_id"
    t.index ["person_id"], name: "index_character_voices_on_person_id"
  end

  create_table "characters", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mal_id"
    t.citext "slug"
    t.integer "primary_media_id"
    t.string "primary_media_type"
    t.jsonb "names", default: {}, null: false
    t.string "canonical_name", null: false
    t.string "other_names", default: [], null: false, array: true
    t.jsonb "description", default: {}, null: false
    t.jsonb "image_data"
    t.index ["mal_id"], name: "character_mal_id", unique: true
    t.index ["mal_id"], name: "index_characters_on_mal_id", unique: true
    t.index ["slug"], name: "index_characters_on_slug"
  end

  create_table "comment_likes", id: :serial, force: :cascade do |t|
    t.integer "comment_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_likes_on_comment_id"
    t.index ["user_id", "comment_id"], name: "index_comment_likes_on_user_id_and_comment_id", unique: true
    t.index ["user_id"], name: "index_comment_likes_on_user_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.text "content"
    t.text "content_formatted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "blocked", default: false, null: false
    t.integer "parent_id"
    t.integer "likes_count", default: 0, null: false
    t.integer "replies_count", default: 0, null: false
    t.datetime "edited_at"
    t.jsonb "embed"
    t.string "ao_id"
    t.datetime "hidden_at"
    t.index ["ao_id"], name: "index_comments_on_ao_id", unique: true
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "community_recommendation_follows", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "community_recommendation_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "community_recommendation_request_id"], name: "index_community_recommendation_follows_on_user_and_request", unique: true
    t.index ["user_id"], name: "index_community_recommendation_follows_on_user_id"
  end

  create_table "community_recommendation_requests", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: {}, null: false
    t.index ["user_id"], name: "index_community_recommendation_requests_on_user_id"
  end

  create_table "community_recommendations", id: :serial, force: :cascade do |t|
    t.integer "media_id"
    t.string "media_type"
    t.integer "anime_id"
    t.integer "drama_id"
    t.integer "manga_id"
    t.integer "community_recommendation_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_id"], name: "index_community_recommendations_on_anime_id"
    t.index ["drama_id"], name: "index_community_recommendations_on_drama_id"
    t.index ["manga_id"], name: "index_community_recommendations_on_manga_id"
    t.index ["media_id", "media_type"], name: "index_community_recommendations_on_media_id_and_media_type", unique: true
    t.index ["media_type", "media_id"], name: "index_community_recommendations_on_media_type_and_media_id"
  end

  create_table "drama_castings", id: :serial, force: :cascade do |t|
    t.integer "drama_character_id", null: false
    t.integer "person_id", null: false
    t.string "locale", null: false
    t.integer "licensor_id"
    t.string "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["drama_character_id", "person_id", "locale"], name: "index_drama_castings_on_character_person_locale", unique: true
    t.index ["drama_character_id"], name: "index_drama_castings_on_drama_character_id"
    t.index ["person_id"], name: "index_drama_castings_on_person_id"
  end

  create_table "drama_characters", id: :serial, force: :cascade do |t|
    t.integer "drama_id", null: false
    t.integer "character_id", null: false
    t.integer "role", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["character_id"], name: "index_drama_characters_on_character_id"
    t.index ["drama_id", "character_id"], name: "index_drama_characters_on_drama_id_and_character_id", unique: true
    t.index ["drama_id"], name: "index_drama_characters_on_drama_id"
  end

  create_table "drama_staff", id: :serial, force: :cascade do |t|
    t.integer "drama_id", null: false
    t.integer "person_id", null: false
    t.string "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["drama_id", "person_id"], name: "index_drama_staff_on_drama_id_and_person_id", unique: true
    t.index ["drama_id"], name: "index_drama_staff_on_drama_id"
    t.index ["person_id"], name: "index_drama_staff_on_person_id"
  end

  create_table "dramas", id: :serial, force: :cascade do |t|
    t.citext "slug", null: false
    t.hstore "titles", default: {}, null: false
    t.string "canonical_title", default: "en_jp", null: false
    t.string "abbreviated_titles", default: [], null: false, array: true
    t.integer "age_rating"
    t.string "age_rating_guide"
    t.integer "episode_count"
    t.integer "episode_length"
    t.integer "subtype"
    t.date "start_date"
    t.date "end_date"
    t.string "youtube_video_id"
    t.string "country", default: "ja", null: false
    t.integer "cover_image_top_offset", default: 0, null: false
    t.decimal "average_rating", precision: 5, scale: 2
    t.hstore "rating_frequencies", default: {}, null: false
    t.integer "user_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "popularity_rank"
    t.integer "rating_rank"
    t.integer "favorites_count", default: 0, null: false
    t.boolean "cover_image_processing"
    t.string "tba"
    t.integer "total_length", default: 0, null: false
    t.text "release_schedule"
    t.jsonb "description", default: {}, null: false
    t.jsonb "poster_image_data"
    t.jsonb "cover_image_data"
    t.string "origin_languages", default: [], array: true
    t.string "origin_countries", default: [], array: true
    t.index ["age_rating"], name: "index_dramas_on_age_rating", comment: "Provide index-only counts by age rating filter"
    t.index ["slug"], name: "index_dramas_on_slug"
  end

  create_table "dramas_genres", id: false, force: :cascade do |t|
    t.integer "drama_id", null: false
    t.integer "genre_id", null: false
  end

  create_table "dramas_media_attributes", id: :serial, force: :cascade do |t|
    t.integer "drama_id", null: false
    t.integer "media_attribute_id", null: false
    t.integer "high_vote_count", default: 0, null: false
    t.integer "neutral_vote_count", default: 0, null: false
    t.integer "low_vote_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drama_id", "media_attribute_id"], name: "index_drama_media_attribute", unique: true
    t.index ["drama_id"], name: "index_dramas_media_attributes_on_drama_id"
    t.index ["media_attribute_id"], name: "index_dramas_media_attributes_on_media_attribute_id"
  end

  create_table "episodes", id: :serial, force: :cascade do |t|
    t.integer "media_id", null: false
    t.integer "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season_number"
    t.date "airdate"
    t.integer "length"
    t.hstore "titles", default: {}, null: false
    t.string "canonical_title"
    t.string "media_type", null: false
    t.integer "relative_number"
    t.boolean "filler"
    t.jsonb "description", default: {}, null: false
    t.jsonb "thumbnail_data"
    t.index ["media_type", "media_id"], name: "index_episodes_on_media_type_and_media_id"
  end

  create_table "favorite_genres_users", id: false, force: :cascade do |t|
    t.integer "genre_id"
    t.integer "user_id"
    t.index ["genre_id", "user_id"], name: "index_favorite_genres_users_on_genre_id_and_user_id", unique: true
  end

  create_table "favorites", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "item_id", null: false
    t.string "item_type", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "fav_rank"
    t.index ["item_id", "item_type"], name: "index_favorites_on_item_id_and_item_type"
    t.index ["user_id", "item_id", "item_type"], name: "index_favorites_on_user_id_and_item_id_and_item_type", unique: true
    t.index ["user_id", "item_type"], name: "index_favorites_on_user_id_and_item_type"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "follows", id: :serial, force: :cascade do |t|
    t.integer "followed_id"
    t.integer "follower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false, null: false
    t.index ["followed_id", "follower_id"], name: "index_follows_on_followed_id_and_follower_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_followed_id"
  end

  create_table "franchises", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "titles", default: {}, null: false
    t.string "canonical_title", default: "en_jp", null: false
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 40
    t.datetime "created_at"
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "gallery_images", id: :serial, force: :cascade do |t|
    t.integer "anime_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name", limit: 255
    t.string "image_content_type", limit: 255
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["anime_id"], name: "index_gallery_images_on_anime_id"
  end

  create_table "genres", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.citext "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: {}, null: false
  end

  create_table "genres_manga", id: false, force: :cascade do |t|
    t.integer "manga_id", null: false
    t.integer "genre_id", null: false
    t.index ["manga_id"], name: "index_genres_manga_on_manga_id"
  end

  create_table "global_stats", id: :serial, force: :cascade do |t|
    t.string "type", null: false
    t.jsonb "stats_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_action_logs", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.string "verb", null: false
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.index ["created_at"], name: "index_group_action_logs_on_created_at"
    t.index ["group_id"], name: "index_group_action_logs_on_group_id"
  end

  create_table "group_bans", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.integer "moderator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.text "notes_formatted"
    t.index ["group_id"], name: "index_group_bans_on_group_id"
    t.index ["user_id"], name: "index_group_bans_on_user_id"
  end

  create_table "group_categories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.citext "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "description", default: {}, null: false
  end

  create_table "group_invites", id: :serial, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.integer "sender_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "revoked_at"
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.index ["group_id"], name: "index_group_invites_on_group_id"
    t.index ["sender_id"], name: "index_group_invites_on_sender_id"
    t.index ["user_id"], name: "index_group_invites_on_user_id"
  end

  create_table "group_member_notes", id: :serial, force: :cascade do |t|
    t.integer "group_member_id", null: false
    t.integer "user_id", null: false
    t.text "content", null: false
    t.text "content_formatted", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_members", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "rank", default: 0, null: false
    t.integer "unread_count", default: 0, null: false
    t.boolean "hidden", default: false, null: false
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["rank"], name: "index_group_members_on_rank"
    t.index ["user_id", "group_id"], name: "index_group_members_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "group_neighbors", id: :serial, force: :cascade do |t|
    t.integer "source_id", null: false
    t.integer "destination_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["destination_id"], name: "index_group_neighbors_on_destination_id"
    t.index ["source_id"], name: "index_group_neighbors_on_source_id"
  end

  create_table "group_permissions", id: :serial, force: :cascade do |t|
    t.integer "group_member_id", null: false
    t.integer "permission", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_member_id"], name: "index_group_permissions_on_group_member_id"
  end

  create_table "group_reports", id: :serial, force: :cascade do |t|
    t.text "explanation"
    t.integer "reason", null: false
    t.integer "status", default: 0, null: false
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.integer "naughty_id", null: false
    t.string "naughty_type", null: false
    t.integer "moderator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_reports_on_group_id"
    t.index ["naughty_type", "naughty_id"], name: "index_group_reports_on_naughty_type_and_naughty_id"
    t.index ["status"], name: "index_group_reports_on_status"
    t.index ["user_id"], name: "index_group_reports_on_user_id"
  end

  create_table "group_ticket_messages", id: :serial, force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.integer "user_id", null: false
    t.integer "kind", default: 0, null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_group_ticket_messages_on_ticket_id"
  end

  create_table "group_tickets", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.integer "assignee_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "first_message_id"
    t.index ["assignee_id"], name: "index_group_tickets_on_assignee_id"
    t.index ["group_id"], name: "index_group_tickets_on_group_id"
    t.index ["status"], name: "index_group_tickets_on_status"
    t.index ["user_id"], name: "index_group_tickets_on_user_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.citext "slug", null: false
    t.text "about", default: "", null: false
    t.integer "members_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "rules"
    t.text "rules_formatted"
    t.boolean "nsfw", default: false, null: false
    t.integer "privacy", default: 0, null: false
    t.string "locale"
    t.string "tags", default: [], null: false, array: true
    t.integer "leaders_count", default: 0, null: false
    t.integer "neighbors_count", default: 0, null: false
    t.boolean "featured", default: false, null: false
    t.integer "category_id", null: false
    t.string "tagline", limit: 60
    t.datetime "last_activity_at"
    t.integer "pinned_post_id"
    t.jsonb "avatar_data"
    t.jsonb "cover_image_data"
    t.index ["category_id"], name: "index_groups_on_category_id"
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "hashtags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", default: 0, null: false
    t.integer "item_id"
    t.string "item_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "installments", id: :serial, force: :cascade do |t|
    t.integer "media_id"
    t.integer "franchise_id"
    t.string "media_type", null: false
    t.integer "release_order"
    t.integer "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "alternative_order"
    t.index ["franchise_id"], name: "index_installments_on_franchise_id"
    t.index ["media_type", "media_id"], name: "index_installments_on_media_type_and_media_id"
  end

  create_table "leader_chat_messages", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.text "content", null: false
    t.text "content_formatted", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "edited_at"
    t.index ["group_id"], name: "index_leader_chat_messages_on_group_id"
    t.index ["user_id"], name: "index_leader_chat_messages_on_user_id"
  end

  create_table "library_entries", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "media_id", null: false
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "progress", default: 0, null: false
    t.boolean "private", default: false, null: false
    t.text "notes"
    t.integer "reconsume_count", default: 0, null: false
    t.boolean "reconsuming", default: false, null: false
    t.string "media_type", null: false
    t.integer "volumes_owned", default: 0, null: false
    t.boolean "nsfw", default: false, null: false
    t.integer "anime_id"
    t.integer "manga_id"
    t.integer "drama_id"
    t.integer "rating"
    t.integer "time_spent", default: 0, null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "progressed_at"
    t.integer "media_reaction_id"
    t.integer "reaction_skipped", default: 0, null: false
    t.index ["anime_id", "id"], name: "index_library_entries_on_anime_id_and_id", where: "(anime_id IS NOT NULL)", comment: "Prevent pkey scans on small limits"
    t.index ["anime_id"], name: "index_library_entries_on_anime_id"
    t.index ["anime_id"], name: "index_library_entries_on_anime_id_partial", where: "(anime_id IS NOT NULL)"
    t.index ["drama_id", "id"], name: "index_library_entries_on_drama_id_and_id", where: "(drama_id IS NOT NULL)", comment: "Prevent pkey scans on small limits"
    t.index ["manga_id", "id"], name: "index_library_entries_on_manga_id_and_id", where: "(manga_id IS NOT NULL)", comment: "Prevent pkey scans on small limits"
    t.index ["manga_id"], name: "index_library_entries_on_manga_id"
    t.index ["manga_id"], name: "index_library_entries_on_manga_id_partial", where: "(manga_id IS NOT NULL)"
    t.index ["user_id", "anime_id"], name: "library_entries_user_id_anime_id_idx"
    t.index ["user_id", "media_type", "media_id"], name: "index_library_entries_on_user_id_and_media_type_and_media_id", unique: true
    t.index ["user_id", "status"], name: "index_library_entries_on_user_id_and_status"
    t.index ["user_id"], name: "index_library_entries_on_user_id"
  end

  create_table "library_entry_logs", id: :serial, force: :cascade do |t|
    t.integer "linked_account_id", null: false
    t.string "media_type", null: false
    t.integer "media_id", null: false
    t.integer "progress"
    t.integer "rating"
    t.integer "reconsume_count"
    t.boolean "reconsuming"
    t.integer "status"
    t.integer "volumes_owned"
    t.string "action_performed", default: "create", null: false
    t.integer "sync_status", default: 0, null: false
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["linked_account_id"], name: "index_library_entry_logs_on_linked_account_id"
  end

  create_table "library_events", id: :serial, force: :cascade do |t|
    t.integer "library_entry_id", null: false
    t.integer "user_id", null: false
    t.integer "anime_id"
    t.integer "manga_id"
    t.integer "drama_id"
    t.integer "kind", null: false
    t.jsonb "changed_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anime_id"], name: "index_library_events_on_anime_id", where: "(anime_id IS NOT NULL)"
    t.index ["drama_id"], name: "index_library_events_on_drama_id", where: "(drama_id IS NOT NULL)"
    t.index ["library_entry_id"], name: "index_library_events_on_library_entry_id"
    t.index ["manga_id"], name: "index_library_events_on_manga_id", where: "(manga_id IS NOT NULL)"
    t.index ["user_id"], name: "index_library_events_on_user_id"
  end

  create_table "linked_accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "external_user_id", null: false
    t.boolean "share_to", default: false, null: false
    t.boolean "share_from", default: false, null: false
    t.string "encrypted_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_token_iv"
    t.string "type", null: false
    t.boolean "sync_to", default: false, null: false
    t.string "disabled_reason"
    t.text "session_data"
    t.index ["user_id"], name: "index_linked_accounts_on_user_id"
  end

  create_table "list_imports", id: :serial, force: :cascade do |t|
    t.string "type", null: false
    t.integer "user_id", null: false
    t.integer "strategy", null: false
    t.string "input_file_file_name"
    t.string "input_file_content_type"
    t.integer "input_file_file_size"
    t.datetime "input_file_updated_at"
    t.text "input_text"
    t.integer "status", default: 0, null: false
    t.integer "progress"
    t.integer "total"
    t.text "error_message"
    t.text "error_trace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "input_file_data"
  end

  create_table "manga", id: :serial, force: :cascade do |t|
    t.citext "slug"
    t.date "start_date"
    t.date "end_date"
    t.string "serialization", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cover_image_top_offset", default: 0
    t.integer "volume_count"
    t.integer "chapter_count"
    t.integer "subtype", default: 1, null: false
    t.decimal "average_rating", precision: 5, scale: 2
    t.hstore "rating_frequencies", default: {}, null: false
    t.hstore "titles", default: {}, null: false
    t.string "canonical_title", default: "en_jp", null: false
    t.string "abbreviated_titles", default: [], null: false, array: true
    t.integer "user_count", default: 0, null: false
    t.integer "popularity_rank"
    t.integer "rating_rank"
    t.integer "age_rating"
    t.string "age_rating_guide"
    t.integer "favorites_count", default: 0, null: false
    t.boolean "cover_image_processing"
    t.string "tba"
    t.integer "chapter_count_guess"
    t.text "release_schedule"
    t.string "original_locale"
    t.jsonb "description", default: {}, null: false
    t.jsonb "poster_image_data"
    t.jsonb "cover_image_data"
    t.string "origin_languages", default: [], array: true
    t.string "origin_countries", default: [], array: true
    t.index ["age_rating"], name: "index_manga_on_age_rating", comment: "Provide index-only counts by age rating filter"
    t.index ["average_rating"], name: "manga_average_rating_idx"
    t.index ["slug"], name: "index_manga_on_slug"
    t.index ["user_count"], name: "manga_user_count_idx"
  end

  create_table "manga_characters", id: :serial, force: :cascade do |t|
    t.integer "manga_id", null: false
    t.integer "character_id", null: false
    t.integer "role", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["character_id"], name: "index_manga_characters_on_character_id"
    t.index ["manga_id", "character_id"], name: "index_manga_characters_on_manga_id_and_character_id", unique: true
    t.index ["manga_id"], name: "index_manga_characters_on_manga_id"
  end

  create_table "manga_media_attributes", id: :serial, force: :cascade do |t|
    t.integer "manga_id", null: false
    t.integer "media_attribute_id", null: false
    t.integer "high_vote_count", default: 0, null: false
    t.integer "neutral_vote_count", default: 0, null: false
    t.integer "low_vote_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manga_id", "media_attribute_id"], name: "index_manga_media_attribute", unique: true
    t.index ["manga_id"], name: "index_manga_media_attributes_on_manga_id"
    t.index ["media_attribute_id"], name: "index_manga_media_attributes_on_media_attribute_id"
  end

  create_table "manga_staff", id: :serial, force: :cascade do |t|
    t.integer "manga_id", null: false
    t.integer "person_id", null: false
    t.string "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["manga_id", "person_id"], name: "index_manga_staff_on_manga_id_and_person_id", unique: true
    t.index ["manga_id"], name: "index_manga_staff_on_manga_id"
    t.index ["person_id"], name: "index_manga_staff_on_person_id"
  end

  create_table "mappings", id: :serial, force: :cascade do |t|
    t.string "external_site", null: false
    t.string "external_id", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "issue"
    t.index ["external_site", "external_id", "item_type", "item_id"], name: "index_mappings_on_external_and_item", unique: true
    t.index ["item_type", "item_id"], name: "index_mappings_on_item_type_and_item_id"
  end

  create_table "media_attribute_votes", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "anime_media_attributes_id"
    t.integer "manga_media_attributes_id"
    t.integer "dramas_media_attributes_id"
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.integer "vote", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "media_id", "media_type"], name: "index_user_media_on_media_attr_votes", unique: true
    t.index ["user_id"], name: "index_media_attribute_votes_on_user_id"
  end

  create_table "media_attributes", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "high_title", null: false
    t.string "neutral_title", null: false
    t.string "low_title", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_media_attributes_on_slug"
    t.index ["title"], name: "index_media_attributes_on_title"
  end

  create_table "media_categories", force: :cascade do |t|
    t.string "media_type", null: false
    t.bigint "media_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_media_categories_on_category_id"
    t.index ["media_type", "media_id"], name: "index_media_categories_on_media_type_and_media_id"
  end

  create_table "media_characters", id: :serial, force: :cascade do |t|
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.integer "character_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_media_characters_on_character_id"
    t.index ["media_type", "media_id"], name: "index_media_characters_on_media_type_and_media_id"
  end

  create_table "media_ignores", id: :serial, force: :cascade do |t|
    t.integer "media_id"
    t.string "media_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_type", "media_id"], name: "index_media_ignores_on_media_type_and_media_id"
    t.index ["user_id"], name: "index_media_ignores_on_user_id"
  end

  create_table "media_productions", id: :serial, force: :cascade do |t|
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.integer "company_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_media_productions_on_company_id"
    t.index ["media_type", "media_id"], name: "index_media_productions_on_media_type_and_media_id"
  end

  create_table "media_reaction_votes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "media_reaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_reaction_id", "user_id"], name: "index_media_reaction_votes_on_media_reaction_id_and_user_id", unique: true
    t.index ["media_reaction_id"], name: "index_media_reaction_votes_on_media_reaction_id"
    t.index ["user_id"], name: "index_media_reaction_votes_on_user_id"
  end

  create_table "media_reactions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.integer "anime_id"
    t.integer "manga_id"
    t.integer "drama_id"
    t.integer "library_entry_id"
    t.integer "up_votes_count", default: 0, null: false
    t.integer "progress", default: 0, null: false
    t.string "reaction", limit: 140
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "hidden_at"
    t.index ["anime_id"], name: "index_media_reactions_on_anime_id"
    t.index ["deleted_at"], name: "index_media_reactions_on_deleted_at"
    t.index ["drama_id"], name: "index_media_reactions_on_drama_id"
    t.index ["library_entry_id"], name: "index_media_reactions_on_library_entry_id"
    t.index ["manga_id"], name: "index_media_reactions_on_manga_id"
    t.index ["media_type", "media_id", "user_id"], name: "index_media_reactions_on_media_type_and_media_id_and_user_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["user_id"], name: "index_media_reactions_on_user_id"
  end

  create_table "media_relationships", id: :serial, force: :cascade do |t|
    t.integer "source_id", null: false
    t.string "source_type", null: false
    t.integer "destination_id", null: false
    t.string "destination_type", null: false
    t.integer "role", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["source_type", "source_id"], name: "index_media_relationships_on_source_type_and_source_id"
  end

  create_table "media_staff", id: :serial, force: :cascade do |t|
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.integer "person_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["media_type", "media_id"], name: "index_media_staff_on_media_type_and_media_id"
    t.index ["person_id"], name: "index_media_staff_on_person_id"
  end

  create_table "moderator_action_logs", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.string "verb", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "not_interesteds", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "media_id"
    t.string "media_type", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_not_interesteds_on_user_id"
  end

  create_table "notification_settings", id: :serial, force: :cascade do |t|
    t.integer "setting_type", null: false
    t.integer "user_id", null: false
    t.boolean "email_enabled", default: true
    t.boolean "web_enabled", default: true
    t.boolean "mobile_enabled", default: true
    t.boolean "fb_messenger_enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notification_settings_on_user_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "source_id"
    t.string "source_type", limit: 255
    t.hstore "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notification_type", limit: 255
    t.boolean "seen", default: false
    t.index ["source_id"], name: "index_notifications_on_source_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "owner_id"
    t.string "owner_type"
    t.boolean "confidential", default: true, null: false
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "one_signal_players", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "player_id"
    t.integer "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_one_signal_players_on_user_id"
  end

  create_table "partner_codes", id: :serial, force: :cascade do |t|
    t.integer "partner_deal_id", null: false
    t.string "code", limit: 255, null: false
    t.integer "user_id"
    t.datetime "expires_at"
    t.datetime "claimed_at"
    t.index ["partner_deal_id", "user_id"], name: "index_partner_codes_on_partner_deal_id_and_user_id"
  end

  create_table "partner_deals", id: :serial, force: :cascade do |t|
    t.string "deal_title", limit: 255, null: false
    t.string "partner_name", limit: 255, null: false
    t.string "valid_countries", limit: 255, default: [], null: false, array: true
    t.string "partner_logo_file_name", limit: 255
    t.string "partner_logo_content_type", limit: 255
    t.integer "partner_logo_file_size"
    t.datetime "partner_logo_updated_at"
    t.text "deal_url", null: false
    t.text "deal_description", null: false
    t.text "redemption_info", null: false
    t.boolean "active", default: true, null: false
    t.integer "recurring", default: 0
    t.index ["valid_countries"], name: "index_partner_deals_on_valid_countries", using: :gin
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "names", default: {}, null: false
    t.string "canonical_name", null: false
    t.string "other_names", default: [], null: false, array: true
    t.date "birthday"
    t.citext "slug"
    t.jsonb "description", default: {}, null: false
    t.jsonb "image_data"
    t.index ["slug"], name: "index_people_on_slug", unique: true
  end

  create_table "post_follows", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "post_id"
    t.index ["post_id"], name: "index_post_follows_on_post_id"
    t.index ["user_id"], name: "index_post_follows_on_user_id"
  end

  create_table "post_likes", id: :serial, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_likes_on_post_id"
    t.index ["user_id"], name: "index_post_likes_on_user_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "target_user_id"
    t.text "content"
    t.text "content_formatted"
    t.integer "media_id"
    t.string "media_type"
    t.boolean "spoiler", default: false, null: false
    t.boolean "nsfw", default: false, null: false
    t.boolean "blocked", default: false, null: false
    t.integer "spoiled_unit_id"
    t.string "spoiled_unit_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "target_group_id"
    t.integer "post_likes_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "top_level_comments_count", default: 0, null: false
    t.datetime "edited_at"
    t.string "target_interest"
    t.jsonb "embed"
    t.integer "community_recommendation_id"
    t.string "ao_id"
    t.integer "edited_by_id"
    t.integer "locked_by_id"
    t.datetime "locked_at"
    t.integer "locked_reason"
    t.datetime "hidden_at"
    t.index ["ao_id"], name: "index_posts_on_ao_id", unique: true
    t.index ["community_recommendation_id"], name: "index_posts_on_community_recommendation_id"
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["locked_by_id"], name: "index_posts_on_locked_by_id"
    t.index ["media_type", "media_id"], name: "posts_media_type_media_id_idx"
    t.index ["target_group_id"], name: "posts_target_group_id_idx"
    t.index ["target_user_id"], name: "posts_target_user_id_idx"
    t.index ["user_id"], name: "posts_user_id_idx"
  end

  create_table "pro_gifts", id: :serial, force: :cascade do |t|
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tier", default: 0, null: false
  end

  create_table "pro_membership_plans", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "amount", null: false
    t.integer "duration", null: false
    t.boolean "recurring", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pro_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "billing_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.integer "tier", default: 0, null: false
    t.index ["user_id"], name: "index_pro_subscriptions_on_user_id"
  end

  create_table "producers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.citext "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profile_link_sites", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "validate_find"
    t.string "validate_replace"
  end

  create_table "profile_links", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "profile_link_site_id", null: false
    t.string "url", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["profile_link_site_id"], name: "index_profile_links_on_profile_link_site_id"
    t.index ["user_id", "profile_link_site_id"], name: "index_profile_links_on_user_id_and_profile_link_site_id", unique: true
    t.index ["user_id"], name: "index_profile_links_on_user_id"
  end

  create_table "quote_likes", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "quote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quote_id"], name: "index_quote_likes_on_quote_id"
    t.index ["user_id"], name: "index_quote_likes_on_user_id"
  end

  create_table "quote_lines", id: :serial, force: :cascade do |t|
    t.integer "quote_id", null: false
    t.integer "character_id", null: false
    t.integer "order", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_quote_lines_on_character_id"
    t.index ["order"], name: "index_quote_lines_on_order"
    t.index ["quote_id"], name: "index_quote_lines_on_quote_id"
  end

  create_table "quotes", id: :serial, force: :cascade do |t|
    t.integer "media_id", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "likes_count", default: 0, null: false
    t.string "media_type", null: false
    t.index ["media_id", "media_type"], name: "index_quotes_on_media_id_and_media_type"
    t.index ["media_id"], name: "index_quotes_on_media_id"
  end

  create_table "rails_admin_histories", id: :serial, force: :cascade do |t|
    t.text "message"
    t.string "username", limit: 255
    t.integer "item"
    t.string "table", limit: 255
    t.integer "month"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "recommendations"
    t.index ["user_id"], name: "index_recommendations_on_user_id"
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.integer "naughty_id", null: false
    t.string "naughty_type", null: false
    t.integer "reason", null: false
    t.text "explanation"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "moderator_id"
    t.index ["naughty_id", "user_id"], name: "index_reports_on_naughty_id_and_user_id", unique: true
    t.index ["naughty_type", "naughty_id"], name: "index_reports_on_naughty_type_and_naughty_id"
    t.index ["status"], name: "index_reports_on_status"
  end

  create_table "reposts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_reposts_on_post_id"
    t.index ["user_id"], name: "index_reposts_on_user_id"
  end

  create_table "review_likes", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "review_id", null: false
    t.integer "user_id", null: false
    t.index ["review_id"], name: "index_review_likes_on_review_id"
    t.index ["user_id"], name: "index_review_likes_on_user_id"
  end

  create_table "reviews", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "media_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "rating", null: false
    t.string "source", limit: 255
    t.integer "likes_count", default: 0
    t.string "media_type"
    t.text "content_formatted", null: false
    t.integer "library_entry_id"
    t.integer "progress"
    t.boolean "spoiler", default: false, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_reviews_on_deleted_at"
    t.index ["likes_count"], name: "index_reviews_on_likes_count"
    t.index ["media_id"], name: "index_reviews_on_media_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "scrapes", id: :serial, force: :cascade do |t|
    t.text "target_url", null: false
    t.string "scraper_name"
    t.integer "depth", default: 0, null: false
    t.integer "max_depth", default: 0, null: false
    t.integer "parent_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "original_ancestor_id"
  end

  create_table "site_announcements", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "image_url"
    t.jsonb "description", default: {}, null: false
  end

  create_table "stats", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "type", null: false
    t.jsonb "stats_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "recalculated_at", null: false
    t.index "((stats_data ->> 'time'::text))", name: "stats_expr_idx"
    t.index ["type", "user_id"], name: "index_stats_on_type_and_user_id", unique: true
    t.index ["user_id"], name: "index_stats_on_user_id"
  end

  create_table "stories", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.hstore "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "story_type", limit: 255
    t.integer "target_id"
    t.string "target_type", limit: 255
    t.integer "library_entry_id"
    t.boolean "adult", default: false
    t.integer "total_votes", default: 0, null: false
    t.integer "group_id"
    t.datetime "deleted_at"
    t.index ["created_at"], name: "index_stories_on_created_at"
    t.index ["deleted_at"], name: "index_stories_on_deleted_at"
    t.index ["group_id"], name: "index_stories_on_group_id"
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "streamers", id: :serial, force: :cascade do |t|
    t.string "site_name", limit: 255, null: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "streaming_links_count", default: 0, null: false
  end

  create_table "streaming_links", id: :serial, force: :cascade do |t|
    t.integer "media_id", null: false
    t.string "media_type", null: false
    t.integer "streamer_id", null: false
    t.string "url", null: false
    t.string "subs", default: ["en"], null: false, array: true
    t.string "dubs", default: ["ja"], null: false, array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "regions", default: ["US"], array: true
    t.index ["media_type", "media_id"], name: "index_streaming_links_on_media_type_and_media_id"
    t.index ["regions"], name: "index_streaming_links_on_regions", using: :gin
    t.index ["streamer_id"], name: "index_streaming_links_on_streamer_id"
  end

  create_table "substories", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "story_id"
    t.integer "target_id"
    t.string "target_type", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.hstore "data"
    t.integer "substory_type", default: 0, null: false
    t.datetime "deleted_at"
  end

  create_table "uploads", id: :serial, force: :cascade do |t|
    t.integer "owner_id"
    t.string "owner_type"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "upload_order"
    t.jsonb "content_data"
    t.index ["owner_type", "owner_id"], name: "index_uploads_on_owner_type_and_owner_id"
    t.index ["user_id"], name: "index_uploads_on_user_id"
  end

  create_table "user_ip_addresses", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.inet "ip_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address", "user_id"], name: "index_user_ip_addresses_on_ip_address_and_user_id", unique: true
    t.index ["user_id"], name: "index_user_ip_addresses_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: ""
    t.string "name", limit: 255
    t.string "password_digest", limit: 255, default: ""
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "recommendations_up_to_date"
    t.string "facebook_id", limit: 255
    t.string "bio", limit: 140, default: "", null: false
    t.boolean "sfw_filter", default: true
    t.string "mal_username", limit: 255
    t.integer "life_spent_on_anime", default: 0, null: false
    t.string "about", limit: 500, default: "", null: false
    t.datetime "confirmed_at"
    t.integer "title_language_preference", default: 0
    t.integer "followers_count", default: 0
    t.integer "following_count", default: 0
    t.boolean "ninja_banned", default: false
    t.datetime "last_recommendations_update"
    t.boolean "subscribed_to_newsletter", default: true
    t.string "location", limit: 255
    t.string "waifu_or_husbando", limit: 255
    t.integer "waifu_id"
    t.boolean "to_follow", default: false
    t.string "dropbox_token", limit: 255
    t.string "dropbox_secret", limit: 255
    t.datetime "last_backup"
    t.integer "approved_edit_count", default: 0
    t.integer "rejected_edit_count", default: 0
    t.datetime "pro_expires_at"
    t.text "about_formatted"
    t.integer "import_status"
    t.string "import_from", limit: 255
    t.string "import_error", limit: 255
    t.string "past_names", default: [], null: false, array: true
    t.string "gender"
    t.date "birthday"
    t.string "twitter_id"
    t.integer "comments_count", default: 0, null: false
    t.integer "likes_given_count", default: 0, null: false
    t.integer "likes_received_count", default: 0, null: false
    t.integer "favorites_count", default: 0, null: false
    t.integer "posts_count", default: 0, null: false
    t.integer "ratings_count", default: 0, null: false
    t.integer "reviews_count", default: 0, null: false
    t.inet "ip_addresses", default: [], array: true
    t.string "previous_email"
    t.integer "pinned_post_id"
    t.string "time_zone"
    t.string "language"
    t.string "country", limit: 2
    t.boolean "share_to_global", default: true, null: false
    t.string "title"
    t.boolean "profile_completed", default: false, null: false
    t.boolean "feed_completed", default: false, null: false
    t.integer "rating_system", default: 0, null: false
    t.integer "theme", default: 0, null: false
    t.datetime "deleted_at"
    t.integer "media_reactions_count", default: 0, null: false
    t.integer "status", default: 1, null: false
    t.citext "slug"
    t.string "ao_id"
    t.string "ao_password"
    t.string "ao_facebook_id"
    t.integer "ao_pro"
    t.string "ao_imported"
    t.datetime "pro_started_at"
    t.integer "max_pro_streak"
    t.string "stripe_customer_id"
    t.integer "quotes_count", default: 0, null: false
    t.integer "pro_tier"
    t.string "pro_message"
    t.string "pro_discord_user"
    t.integer "email_status", default: 0
    t.integer "permissions", default: 0, null: false
    t.jsonb "avatar_data"
    t.jsonb "cover_image_data"
    t.integer "sfw_filter_preference", default: 0, null: false
    t.index "lower((email)::text)", name: "users_lower_idx"
    t.index "lower((name)::text), id", name: "index_users_on_lower_name_and_id", comment: "Unknown who is querying this, but it is painfully slow without this index"
    t.index ["ao_id"], name: "index_users_on_ao_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["facebook_id"], name: "index_users_on_facebook_id", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["to_follow"], name: "index_users_on_to_follow"
    t.index ["waifu_id"], name: "index_users_on_waifu_id"
  end

  create_table "users_roles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "item_type", limit: 255, null: false
    t.integer "user_id"
    t.json "object", null: false
    t.json "object_changes", null: false
    t.integer "state", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "comment", limit: 255
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["user_id"], name: "index_versions_on_user_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "url", limit: 255, null: false
    t.jsonb "embed_data", default: {}, null: false
    t.string "regions", limit: 255, default: ["US"], array: true
    t.integer "episode_id", null: false
    t.integer "streamer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sub_lang", limit: 255
    t.string "dub_lang", limit: 255
    t.string "subs", default: ["en"], array: true
    t.string "dubs", default: ["ja"], array: true
    t.index ["dub_lang"], name: "index_videos_on_dub_lang"
    t.index ["episode_id"], name: "index_videos_on_episode_id"
    t.index ["regions"], name: "index_videos_on_regions", using: :gin
    t.index ["streamer_id"], name: "index_videos_on_streamer_id"
    t.index ["sub_lang"], name: "index_videos_on_sub_lang"
  end

  create_table "volumes", id: :serial, force: :cascade do |t|
    t.jsonb "titles", default: {}, null: false
    t.string "canonical_title"
    t.integer "number", null: false
    t.integer "chapters_count", default: 0, null: false
    t.integer "manga_id", null: false
    t.string "isbn", default: [], null: false, array: true
    t.date "published_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "thumbnail_data"
  end

  create_table "votes", id: :serial, force: :cascade do |t|
    t.integer "target_id", null: false
    t.string "target_type", limit: 255, null: false
    t.integer "user_id", null: false
    t.boolean "positive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_id", "target_type", "user_id"], name: "index_votes_on_target_id_and_target_type_and_user_id", unique: true
    t.index ["user_id", "target_type"], name: "index_votes_on_user_id_and_target_type"
  end

  create_table "wiki_submission_logs", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.bigint "user_id"
    t.bigint "wiki_submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wiki_submission_logs_on_user_id"
    t.index ["wiki_submission_id"], name: "index_wiki_submission_logs_on_wiki_submission_id"
  end

  create_table "wiki_submissions", force: :cascade do |t|
    t.string "title"
    t.text "notes"
    t.integer "status", default: 0, null: false
    t.jsonb "data", default: {}, null: false
    t.bigint "user_id"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "((data -> 'id'::text)), ((data -> 'type'::text))", name: "index_wiki_submission_on_data_id_and_data_type"
    t.index ["parent_id"], name: "index_wiki_submissions_on_parent_id"
    t.index ["user_id"], name: "index_wiki_submissions_on_user_id"
  end

  create_table "wordfilters", force: :cascade do |t|
    t.text "pattern", null: false
    t.boolean "regex_enabled", default: false, null: false
    t.integer "locations", default: 0, null: false
    t.integer "action", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "ama_subscribers", "amas"
  add_foreign_key "amas", "posts", column: "original_post_id"
  add_foreign_key "anime_castings", "anime_characters"
  add_foreign_key "anime_castings", "people"
  add_foreign_key "anime_castings", "producers", column: "licensor_id"
  add_foreign_key "anime_characters", "characters"
  add_foreign_key "anime_media_attributes", "media_attributes"
  add_foreign_key "anime_staff", "people"
  add_foreign_key "blocks", "users", column: "blocked_id"
  add_foreign_key "category_favorites", "categories"
  add_foreign_key "category_favorites", "users"
  add_foreign_key "comment_likes", "comments"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "community_recommendation_follows", "community_recommendation_requests"
  add_foreign_key "community_recommendations", "community_recommendation_requests"
  add_foreign_key "drama_castings", "drama_characters"
  add_foreign_key "drama_castings", "people"
  add_foreign_key "drama_castings", "producers", column: "licensor_id"
  add_foreign_key "drama_characters", "characters"
  add_foreign_key "drama_staff", "people"
  add_foreign_key "dramas_media_attributes", "dramas"
  add_foreign_key "dramas_media_attributes", "media_attributes"
  add_foreign_key "group_action_logs", "groups"
  add_foreign_key "group_action_logs", "users"
  add_foreign_key "group_bans", "groups"
  add_foreign_key "group_bans", "users", column: "moderator_id"
  add_foreign_key "group_invites", "groups"
  add_foreign_key "group_invites", "users", column: "sender_id"
  add_foreign_key "group_member_notes", "group_members"
  add_foreign_key "group_neighbors", "groups", column: "destination_id"
  add_foreign_key "group_permissions", "group_members"
  add_foreign_key "group_reports", "groups"
  add_foreign_key "group_reports", "users", column: "moderator_id"
  add_foreign_key "group_ticket_messages", "group_tickets", column: "ticket_id"
  add_foreign_key "group_tickets", "group_ticket_messages", column: "first_message_id"
  add_foreign_key "group_tickets", "groups"
  add_foreign_key "group_tickets", "users", column: "assignee_id"
  add_foreign_key "groups", "group_categories", column: "category_id"
  add_foreign_key "groups", "posts", column: "pinned_post_id"
  add_foreign_key "leader_chat_messages", "groups"
  add_foreign_key "library_entries", "media_reactions"
  add_foreign_key "manga_characters", "characters"
  add_foreign_key "manga_media_attributes", "media_attributes"
  add_foreign_key "manga_staff", "people"
  add_foreign_key "media_reaction_votes", "media_reactions"
  add_foreign_key "post_follows", "posts"
  add_foreign_key "posts", "community_recommendations"
  add_foreign_key "posts", "users", column: "target_user_id"
  add_foreign_key "profile_links", "profile_link_sites"
  add_foreign_key "reports", "users", column: "moderator_id"
  add_foreign_key "reposts", "posts"
  add_foreign_key "reposts", "users"
  add_foreign_key "site_announcements", "users"
  add_foreign_key "streaming_links", "streamers"
  add_foreign_key "users", "posts", column: "pinned_post_id"
  add_foreign_key "wiki_submission_logs", "users"
  add_foreign_key "wiki_submission_logs", "wiki_submissions"
  add_foreign_key "wiki_submissions", "users"

  create_view "media_castings", sql_definition: <<-SQL
      SELECT concat('c', mc.id, 'v', cv.id) AS id,
      mc.media_type,
      mc.media_id,
      cv.person_id,
      mc.character_id,
          CASE cv.locale
              WHEN 'fr'::text THEN 'French'::text
              WHEN 'he'::text THEN 'Hebrew'::text
              WHEN 'ja_jp'::text THEN 'Japanese'::text
              WHEN 'hu'::text THEN 'Hungarian'::text
              WHEN 'jp'::text THEN 'Japanese'::text
              WHEN 'pt_br'::text THEN 'Brazilian'::text
              WHEN 'ko'::text THEN 'Korean'::text
              WHEN 'it'::text THEN 'Italian'::text
              WHEN 'en'::text THEN 'English'::text
              WHEN 'us'::text THEN 'English'::text
              WHEN 'es'::text THEN 'Spanish'::text
              WHEN 'de'::text THEN 'German'::text
              ELSE NULL::text
          END AS language,
      (mc.role = 0) AS featured,
      row_number() OVER (PARTITION BY mc.media_type, mc.media_id ORDER BY mc.role, mc.id) AS "order",
      'Voice Actor'::text AS role,
      true AS voice_actor,
      LEAST(mc.created_at, cv.created_at) AS created_at,
      GREATEST(mc.updated_at, cv.updated_at) AS updated_at
     FROM (media_characters mc
       JOIN character_voices cv ON ((mc.id = cv.media_character_id)))
  UNION
   SELECT concat('c', mc.id) AS id,
      mc.media_type,
      mc.media_id,
      NULL::integer AS person_id,
      mc.character_id,
      NULL::text AS language,
      (mc.role = 0) AS featured,
      row_number() OVER (PARTITION BY mc.media_type, mc.media_id ORDER BY mc.role, mc.id) AS "order",
      NULL::text AS role,
      false AS voice_actor,
      mc.created_at,
      mc.updated_at
     FROM (media_characters mc
       LEFT JOIN character_voices cv ON ((mc.id = cv.media_character_id)))
    WHERE (cv.id IS NULL)
  UNION
   SELECT concat('s', ms.id) AS id,
      ms.media_type,
      ms.media_id,
      ms.person_id,
      NULL::integer AS character_id,
      NULL::text AS language,
      false AS featured,
      row_number() OVER (PARTITION BY ms.media_type, ms.media_id ORDER BY ms.id) AS "order",
      ms.role,
      false AS voice_actor,
      ms.created_at,
      ms.updated_at
     FROM media_staff ms;
  SQL
end
