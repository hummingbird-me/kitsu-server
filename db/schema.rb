# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180110055601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"

  create_table "ama_subscribers", force: :cascade do |t|
    t.integer  "ama_id",     null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ama_subscribers", ["ama_id", "user_id"], name: "index_ama_subscribers_on_ama_id_and_user_id", unique: true, using: :btree
  add_index "ama_subscribers", ["ama_id"], name: "index_ama_subscribers_on_ama_id", using: :btree
  add_index "ama_subscribers", ["user_id"], name: "index_ama_subscribers_on_user_id", using: :btree

  create_table "amas", force: :cascade do |t|
    t.string   "description",                       null: false
    t.integer  "author_id",                         null: false
    t.integer  "original_post_id",                  null: false
    t.integer  "ama_subscribers_count", default: 0, null: false
    t.datetime "start_date",                        null: false
    t.datetime "end_date",                          null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "amas", ["author_id"], name: "index_amas_on_author_id", using: :btree
  add_index "amas", ["original_post_id"], name: "index_amas_on_original_post_id", using: :btree

  create_table "anime", force: :cascade do |t|
    t.string   "slug",                      limit: 255
    t.integer  "age_rating"
    t.integer  "episode_count"
    t.integer  "episode_length"
    t.text     "synopsis",                                                      default: "",      null: false
    t.string   "youtube_video_id",          limit: 255
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
    t.string   "cover_image_file_name",     limit: 255
    t.string   "cover_image_content_type",  limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.decimal  "average_rating",                        precision: 5, scale: 2
    t.integer  "user_count",                                                    default: 0,       null: false
    t.string   "age_rating_guide",          limit: 255
    t.integer  "subtype",                                                       default: 1,       null: false
    t.date     "start_date"
    t.date     "end_date"
    t.hstore   "rating_frequencies",                                            default: {},      null: false
    t.string   "poster_image_file_name",    limit: 255
    t.string   "poster_image_content_type", limit: 255
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
    t.integer  "cover_image_top_offset",                                        default: 0,       null: false
    t.hstore   "titles",                                                        default: {},      null: false
    t.string   "canonical_title",                                               default: "en_jp", null: false
    t.string   "abbreviated_titles",                                                                           array: true
    t.integer  "popularity_rank"
    t.integer  "rating_rank"
    t.integer  "favorites_count",                                               default: 0,       null: false
    t.boolean  "cover_image_processing"
    t.string   "tba"
    t.integer  "episode_count_guess"
    t.text     "poster_image_meta"
    t.text     "cover_image_meta"
    t.integer  "total_length"
  end

  add_index "anime", ["age_rating"], name: "index_anime_on_age_rating", using: :btree
  add_index "anime", ["average_rating"], name: "index_anime_on_wilson_ci", order: {"average_rating"=>:desc}, using: :btree
  add_index "anime", ["slug"], name: "index_anime_on_slug", unique: true, using: :btree
  add_index "anime", ["user_count"], name: "index_anime_on_user_count", using: :btree

  create_table "anime_castings", force: :cascade do |t|
    t.integer  "anime_character_id", null: false
    t.integer  "person_id",          null: false
    t.string   "locale",             null: false
    t.integer  "licensor_id"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "anime_castings", ["anime_character_id", "person_id", "locale"], name: "index_anime_castings_on_character_person_locale", unique: true, using: :btree
  add_index "anime_castings", ["anime_character_id"], name: "index_anime_castings_on_anime_character_id", using: :btree
  add_index "anime_castings", ["person_id"], name: "index_anime_castings_on_person_id", using: :btree

  create_table "anime_categories", id: false, force: :cascade do |t|
    t.integer "anime_id",    null: false
    t.integer "category_id", null: false
  end

  create_table "anime_characters", force: :cascade do |t|
    t.integer  "anime_id",                 null: false
    t.integer  "character_id",             null: false
    t.integer  "role",         default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "anime_characters", ["anime_id", "character_id"], name: "index_anime_characters_on_anime_id_and_character_id", unique: true, using: :btree
  add_index "anime_characters", ["anime_id"], name: "index_anime_characters_on_anime_id", using: :btree
  add_index "anime_characters", ["character_id"], name: "index_anime_characters_on_character_id", using: :btree

  create_table "anime_genres", id: false, force: :cascade do |t|
    t.integer "anime_id", null: false
    t.integer "genre_id", null: false
  end

  add_index "anime_genres", ["anime_id"], name: "index_anime_genres_on_anime_id", using: :btree
  add_index "anime_genres", ["genre_id"], name: "index_anime_genres_on_genre_id", using: :btree

  create_table "anime_media_attributes", force: :cascade do |t|
    t.integer  "anime_id",                       null: false
    t.integer  "media_attribute_id",             null: false
    t.integer  "high_vote_count",    default: 0, null: false
    t.integer  "neutral_vote_count", default: 0, null: false
    t.integer  "low_vote_count",     default: 0, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "anime_media_attributes", ["anime_id", "media_attribute_id"], name: "index_anime_media_attribute", unique: true, using: :btree
  add_index "anime_media_attributes", ["anime_id"], name: "index_anime_media_attributes_on_anime_id", using: :btree
  add_index "anime_media_attributes", ["media_attribute_id"], name: "index_anime_media_attributes_on_media_attribute_id", using: :btree

  create_table "anime_productions", force: :cascade do |t|
    t.integer  "anime_id",                null: false
    t.integer  "producer_id",             null: false
    t.integer  "role",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "anime_productions", ["anime_id"], name: "index_anime_productions_on_anime_id", using: :btree
  add_index "anime_productions", ["producer_id"], name: "index_anime_productions_on_producer_id", using: :btree

  create_table "anime_staff", force: :cascade do |t|
    t.integer  "anime_id",   null: false
    t.integer  "person_id",  null: false
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "anime_staff", ["anime_id", "person_id"], name: "index_anime_staff_on_anime_id_and_person_id", unique: true, using: :btree
  add_index "anime_staff", ["anime_id"], name: "index_anime_staff_on_anime_id", using: :btree
  add_index "anime_staff", ["person_id"], name: "index_anime_staff_on_person_id", using: :btree

  create_table "blocks", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "blocked_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blocks", ["blocked_id"], name: "index_blocks_on_blocked_id", using: :btree
  add_index "blocks", ["user_id"], name: "index_blocks_on_user_id", using: :btree

  create_table "castings", force: :cascade do |t|
    t.integer  "media_id",                                 null: false
    t.integer  "person_id"
    t.integer  "character_id"
    t.string   "role",         limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "voice_actor",              default: false, null: false
    t.boolean  "featured",                 default: false, null: false
    t.integer  "order"
    t.string   "language",     limit: 255
    t.string   "media_type",   limit: 255,                 null: false
  end

  add_index "castings", ["character_id"], name: "index_castings_on_character_id", using: :btree
  add_index "castings", ["media_id", "media_type"], name: "index_castings_on_media_id_and_media_type", using: :btree
  add_index "castings", ["person_id"], name: "index_castings_on_person_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title",                              null: false
    t.string   "description"
    t.string   "slug",                               null: false
    t.integer  "anidb_id"
    t.integer  "parent_id"
    t.integer  "total_media_count",  default: 0,     null: false
    t.boolean  "nsfw",               default: false, null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "child_count",        default: 0,     null: false
  end

  add_index "categories", ["anidb_id"], name: "index_categories_on_anidb_id", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "categories_dramas", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "drama_id",    null: false
  end

  create_table "categories_manga", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "manga_id",    null: false
  end

  create_table "category_favorites", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "category_favorites", ["category_id"], name: "index_category_favorites_on_category_id", using: :btree
  add_index "category_favorites", ["user_id"], name: "index_category_favorites_on_user_id", using: :btree

  create_table "chapters", force: :cascade do |t|
    t.integer  "manga_id"
    t.hstore   "titles",                             default: {},      null: false
    t.string   "canonical_title",                    default: "en_jp", null: false
    t.integer  "number",                                               null: false
    t.integer  "volume_number"
    t.integer  "length"
    t.text     "synopsis"
    t.date     "published"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "thumbnail_file_name",    limit: 255
    t.string   "thumbnail_content_type", limit: 255
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.text     "thumbnail_meta"
  end

  add_index "chapters", ["manga_id"], name: "index_chapters_on_manga_id", using: :btree

  create_table "characters", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "mal_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "slug",               limit: 255
    t.integer  "primary_media_id"
    t.string   "primary_media_type"
  end

  add_index "characters", ["mal_id"], name: "character_mal_id", unique: true, using: :btree
  add_index "characters", ["mal_id"], name: "index_characters_on_mal_id", unique: true, using: :btree

  create_table "comment_likes", force: :cascade do |t|
    t.integer  "comment_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comment_likes", ["comment_id"], name: "index_comment_likes_on_comment_id", using: :btree
  add_index "comment_likes", ["user_id", "comment_id"], name: "index_comment_likes_on_user_id_and_comment_id", unique: true, using: :btree
  add_index "comment_likes", ["user_id"], name: "index_comment_likes_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id",                           null: false
    t.integer  "user_id",                           null: false
    t.text     "content"
    t.text     "content_formatted"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "deleted_at"
    t.boolean  "blocked",           default: false, null: false
    t.integer  "parent_id"
    t.integer  "likes_count",       default: 0,     null: false
    t.integer  "replies_count",     default: 0,     null: false
    t.datetime "edited_at"
    t.jsonb    "embed"
  end

  add_index "comments", ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree
  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "community_recommendation_follows", force: :cascade do |t|
    t.integer  "user_id",                             null: false
    t.integer  "community_recommendation_request_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "community_recommendation_follows", ["user_id", "community_recommendation_request_id"], name: "index_community_recommendation_follows_on_user_and_request", unique: true, using: :btree
  add_index "community_recommendation_follows", ["user_id"], name: "index_community_recommendation_follows_on_user_id", using: :btree

  create_table "community_recommendation_requests", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.string   "title"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "community_recommendation_requests", ["user_id"], name: "index_community_recommendation_requests_on_user_id", using: :btree

  create_table "community_recommendations", force: :cascade do |t|
    t.integer  "media_id"
    t.string   "media_type"
    t.integer  "anime_id"
    t.integer  "drama_id"
    t.integer  "manga_id"
    t.integer  "community_recommendation_request_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "community_recommendations", ["anime_id"], name: "index_community_recommendations_on_anime_id", using: :btree
  add_index "community_recommendations", ["drama_id"], name: "index_community_recommendations_on_drama_id", using: :btree
  add_index "community_recommendations", ["manga_id"], name: "index_community_recommendations_on_manga_id", using: :btree
  add_index "community_recommendations", ["media_id", "media_type"], name: "index_community_recommendations_on_media_id_and_media_type", unique: true, using: :btree
  add_index "community_recommendations", ["media_type", "media_id"], name: "index_community_recommendations_on_media_type_and_media_id", using: :btree

  create_table "drama_castings", force: :cascade do |t|
    t.integer  "drama_character_id", null: false
    t.integer  "person_id",          null: false
    t.string   "locale",             null: false
    t.integer  "licensor_id"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drama_castings", ["drama_character_id", "person_id", "locale"], name: "index_drama_castings_on_character_person_locale", unique: true, using: :btree
  add_index "drama_castings", ["drama_character_id"], name: "index_drama_castings_on_drama_character_id", using: :btree
  add_index "drama_castings", ["person_id"], name: "index_drama_castings_on_person_id", using: :btree

  create_table "drama_characters", force: :cascade do |t|
    t.integer  "drama_id",                 null: false
    t.integer  "character_id",             null: false
    t.integer  "role",         default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drama_characters", ["character_id"], name: "index_drama_characters_on_character_id", using: :btree
  add_index "drama_characters", ["drama_id", "character_id"], name: "index_drama_characters_on_drama_id_and_character_id", unique: true, using: :btree
  add_index "drama_characters", ["drama_id"], name: "index_drama_characters_on_drama_id", using: :btree

  create_table "drama_staff", force: :cascade do |t|
    t.integer  "drama_id",   null: false
    t.integer  "person_id",  null: false
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drama_staff", ["drama_id", "person_id"], name: "index_drama_staff_on_drama_id_and_person_id", unique: true, using: :btree
  add_index "drama_staff", ["drama_id"], name: "index_drama_staff_on_drama_id", using: :btree
  add_index "drama_staff", ["person_id"], name: "index_drama_staff_on_person_id", using: :btree

  create_table "dramas", force: :cascade do |t|
    t.string   "slug",                                                                null: false
    t.hstore   "titles",                                            default: {},      null: false
    t.string   "canonical_title",                                   default: "en_jp", null: false
    t.string   "abbreviated_titles",                                                               array: true
    t.integer  "age_rating"
    t.string   "age_rating_guide"
    t.integer  "episode_count"
    t.integer  "episode_length"
    t.integer  "subtype"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "synopsis"
    t.string   "youtube_video_id"
    t.string   "country",                                           default: "ja",    null: false
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "poster_image_file_name"
    t.string   "poster_image_content_type"
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
    t.integer  "cover_image_top_offset",                            default: 0,       null: false
    t.decimal  "average_rating",            precision: 5, scale: 2
    t.hstore   "rating_frequencies",                                default: {},      null: false
    t.integer  "user_count",                                        default: 0,       null: false
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.integer  "popularity_rank"
    t.integer  "rating_rank"
    t.integer  "favorites_count",                                   default: 0,       null: false
    t.boolean  "cover_image_processing"
    t.string   "tba"
    t.text     "poster_image_meta"
    t.text     "cover_image_meta"
  end

  add_index "dramas", ["slug"], name: "index_dramas_on_slug", using: :btree

  create_table "dramas_genres", id: false, force: :cascade do |t|
    t.integer "drama_id", null: false
    t.integer "genre_id", null: false
  end

  create_table "dramas_media_attributes", force: :cascade do |t|
    t.integer  "drama_id",                       null: false
    t.integer  "media_attribute_id",             null: false
    t.integer  "high_vote_count",    default: 0, null: false
    t.integer  "neutral_vote_count", default: 0, null: false
    t.integer  "low_vote_count",     default: 0, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "dramas_media_attributes", ["drama_id", "media_attribute_id"], name: "index_drama_media_attribute", unique: true, using: :btree
  add_index "dramas_media_attributes", ["drama_id"], name: "index_dramas_media_attributes_on_drama_id", using: :btree
  add_index "dramas_media_attributes", ["media_attribute_id"], name: "index_dramas_media_attributes_on_media_attribute_id", using: :btree

  create_table "episodes", force: :cascade do |t|
    t.integer  "media_id",                                             null: false
    t.integer  "number"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "season_number"
    t.text     "synopsis"
    t.string   "thumbnail_file_name",    limit: 255
    t.string   "thumbnail_content_type", limit: 255
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.date     "airdate"
    t.integer  "length"
    t.hstore   "titles",                             default: {},      null: false
    t.string   "canonical_title",                    default: "en_jp", null: false
    t.string   "media_type",                                           null: false
    t.integer  "relative_number"
    t.text     "thumbnail_meta"
  end

  add_index "episodes", ["media_type", "media_id"], name: "index_episodes_on_media_type_and_media_id", using: :btree

  create_table "favorite_genres_users", id: false, force: :cascade do |t|
    t.integer "genre_id"
    t.integer "user_id"
  end

  add_index "favorite_genres_users", ["genre_id", "user_id"], name: "index_favorite_genres_users_on_genre_id_and_user_id", unique: true, using: :btree

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id",                               null: false
    t.integer  "item_id",                               null: false
    t.string   "item_type",  limit: 255,                null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "fav_rank",               default: 9999, null: false
  end

  add_index "favorites", ["item_id", "item_type"], name: "index_favorites_on_item_id_and_item_type", using: :btree
  add_index "favorites", ["user_id", "item_id", "item_type"], name: "index_favorites_on_user_id_and_item_id_and_item_type", unique: true, using: :btree
  add_index "favorites", ["user_id", "item_type"], name: "index_favorites_on_user_id_and_item_type", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer  "followed_id"
    t.integer  "follower_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "hidden",      default: false, null: false
  end

  add_index "follows", ["followed_id", "follower_id"], name: "index_follows_on_followed_id_and_follower_id", unique: true, using: :btree
  add_index "follows", ["follower_id"], name: "index_follows_on_followed_id", using: :btree

  create_table "franchises", force: :cascade do |t|
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.hstore   "titles",          default: {},      null: false
    t.string   "canonical_title", default: "en_jp", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gallery_images", force: :cascade do |t|
    t.integer  "anime_id"
    t.text     "description"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "gallery_images", ["anime_id"], name: "index_gallery_images_on_anime_id", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "slug",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "description"
  end

  create_table "genres_manga", id: false, force: :cascade do |t|
    t.integer "manga_id", null: false
    t.integer "genre_id", null: false
  end

  add_index "genres_manga", ["manga_id"], name: "index_genres_manga_on_manga_id", using: :btree

  create_table "group_action_logs", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "group_id",    null: false
    t.string   "verb",        null: false
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at"
  end

  add_index "group_action_logs", ["created_at"], name: "index_group_action_logs_on_created_at", using: :btree
  add_index "group_action_logs", ["group_id"], name: "index_group_action_logs_on_group_id", using: :btree

  create_table "group_bans", force: :cascade do |t|
    t.integer  "group_id",        null: false
    t.integer  "user_id",         null: false
    t.integer  "moderator_id",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "notes"
    t.text     "notes_formatted"
  end

  add_index "group_bans", ["group_id"], name: "index_group_bans_on_group_id", using: :btree
  add_index "group_bans", ["user_id"], name: "index_group_bans_on_user_id", using: :btree

  create_table "group_categories", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "slug",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "group_invites", force: :cascade do |t|
    t.integer  "group_id",    null: false
    t.integer  "user_id",     null: false
    t.integer  "sender_id",   null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "revoked_at"
    t.datetime "accepted_at"
    t.datetime "declined_at"
  end

  add_index "group_invites", ["group_id"], name: "index_group_invites_on_group_id", using: :btree
  add_index "group_invites", ["sender_id"], name: "index_group_invites_on_sender_id", using: :btree
  add_index "group_invites", ["user_id"], name: "index_group_invites_on_user_id", using: :btree

  create_table "group_member_notes", force: :cascade do |t|
    t.integer  "group_member_id",   null: false
    t.integer  "user_id",           null: false
    t.text     "content",           null: false
    t.text     "content_formatted", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "group_members", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "group_id",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank",         default: 0,     null: false
    t.integer  "unread_count", default: 0,     null: false
    t.boolean  "hidden",       default: false, null: false
  end

  add_index "group_members", ["group_id"], name: "index_group_members_on_group_id", using: :btree
  add_index "group_members", ["rank"], name: "index_group_members_on_rank", using: :btree
  add_index "group_members", ["user_id", "group_id"], name: "index_group_members_on_user_id_and_group_id", unique: true, using: :btree
  add_index "group_members", ["user_id"], name: "index_group_members_on_user_id", using: :btree

  create_table "group_neighbors", force: :cascade do |t|
    t.integer  "source_id",      null: false
    t.integer  "destination_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "group_neighbors", ["destination_id"], name: "index_group_neighbors_on_destination_id", using: :btree
  add_index "group_neighbors", ["source_id"], name: "index_group_neighbors_on_source_id", using: :btree

  create_table "group_permissions", force: :cascade do |t|
    t.integer  "group_member_id", null: false
    t.integer  "permission",      null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "group_permissions", ["group_member_id"], name: "index_group_permissions_on_group_member_id", using: :btree

  create_table "group_reports", force: :cascade do |t|
    t.text     "explanation"
    t.integer  "reason",                   null: false
    t.integer  "status",       default: 0, null: false
    t.integer  "group_id",                 null: false
    t.integer  "user_id",                  null: false
    t.integer  "naughty_id",               null: false
    t.string   "naughty_type",             null: false
    t.integer  "moderator_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "group_reports", ["group_id"], name: "index_group_reports_on_group_id", using: :btree
  add_index "group_reports", ["naughty_type", "naughty_id"], name: "index_group_reports_on_naughty_type_and_naughty_id", using: :btree
  add_index "group_reports", ["status"], name: "index_group_reports_on_status", using: :btree
  add_index "group_reports", ["user_id"], name: "index_group_reports_on_user_id", using: :btree

  create_table "group_ticket_messages", force: :cascade do |t|
    t.integer  "ticket_id",              null: false
    t.integer  "user_id",                null: false
    t.integer  "kind",       default: 0, null: false
    t.text     "content",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "group_ticket_messages", ["ticket_id"], name: "index_group_ticket_messages_on_ticket_id", using: :btree

  create_table "group_tickets", force: :cascade do |t|
    t.integer  "user_id",                      null: false
    t.integer  "group_id",                     null: false
    t.integer  "assignee_id"
    t.integer  "status",           default: 0, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "first_message_id"
  end

  add_index "group_tickets", ["assignee_id"], name: "index_group_tickets_on_assignee_id", using: :btree
  add_index "group_tickets", ["group_id"], name: "index_group_tickets_on_group_id", using: :btree
  add_index "group_tickets", ["status"], name: "index_group_tickets_on_status", using: :btree
  add_index "group_tickets", ["user_id"], name: "index_group_tickets_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",                     limit: 255,                 null: false
    t.string   "slug",                     limit: 255,                 null: false
    t.text     "about",                                default: "",    null: false
    t.string   "avatar_file_name",         limit: 255
    t.string   "avatar_content_type",      limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "cover_image_file_name",    limit: 255
    t.string   "cover_image_content_type", limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.integer  "members_count",                        default: 0
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "avatar_processing",                    default: false, null: false
    t.text     "rules"
    t.text     "rules_formatted"
    t.boolean  "nsfw",                                 default: false, null: false
    t.integer  "privacy",                              default: 0,     null: false
    t.string   "locale"
    t.string   "tags",                                 default: [],    null: false, array: true
    t.integer  "leaders_count",                        default: 0,     null: false
    t.integer  "neighbors_count",                      default: 0,     null: false
    t.boolean  "featured",                             default: false, null: false
    t.integer  "category_id",                                          null: false
    t.string   "tagline",                  limit: 60
    t.datetime "last_activity_at"
    t.integer  "pinned_post_id"
    t.text     "avatar_meta"
    t.text     "cover_image_meta"
  end

  add_index "groups", ["category_id"], name: "index_groups_on_category_id", using: :btree
  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree

  create_table "installments", force: :cascade do |t|
    t.integer  "media_id"
    t.integer  "franchise_id"
    t.string   "media_type",               null: false
    t.integer  "position",     default: 0, null: false
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "installments", ["franchise_id"], name: "index_installments_on_franchise_id", using: :btree
  add_index "installments", ["media_type", "media_id"], name: "index_installments_on_media_type_and_media_id", using: :btree

  create_table "leader_chat_messages", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.integer  "group_id",          null: false
    t.text     "content",           null: false
    t.text     "content_formatted", null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "edited_at"
  end

  add_index "leader_chat_messages", ["group_id"], name: "index_leader_chat_messages_on_group_id", using: :btree
  add_index "leader_chat_messages", ["user_id"], name: "index_leader_chat_messages_on_user_id", using: :btree

  create_table "library_entries", force: :cascade do |t|
    t.integer  "user_id",                           null: false
    t.integer  "media_id",                          null: false
    t.integer  "status",                            null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "progress",          default: 0,     null: false
    t.boolean  "private",           default: false, null: false
    t.text     "notes"
    t.integer  "reconsume_count",   default: 0,     null: false
    t.boolean  "reconsuming",       default: false, null: false
    t.string   "media_type",                        null: false
    t.integer  "volumes_owned",     default: 0,     null: false
    t.boolean  "nsfw",              default: false, null: false
    t.integer  "anime_id"
    t.integer  "manga_id"
    t.integer  "drama_id"
    t.integer  "rating"
    t.integer  "time_spent",        default: 0,     null: false
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "progressed_at"
    t.integer  "media_reaction_id"
    t.integer  "reaction_skipped",  default: 0,     null: false
  end

  add_index "library_entries", ["anime_id"], name: "index_library_entries_on_anime_id", using: :btree
  add_index "library_entries", ["drama_id"], name: "index_library_entries_on_drama_id", using: :btree
  add_index "library_entries", ["manga_id"], name: "index_library_entries_on_manga_id", using: :btree
  add_index "library_entries", ["private"], name: "index_library_entries_on_private", using: :btree
  add_index "library_entries", ["user_id", "media_type", "media_id"], name: "index_library_entries_on_user_id_and_media_type_and_media_id", unique: true, using: :btree
  add_index "library_entries", ["user_id", "media_type"], name: "index_library_entries_on_user_id_and_media_type", using: :btree
  add_index "library_entries", ["user_id", "status"], name: "index_library_entries_on_user_id_and_status", using: :btree
  add_index "library_entries", ["user_id"], name: "index_library_entries_on_user_id", using: :btree

  create_table "library_entry_logs", force: :cascade do |t|
    t.integer  "linked_account_id",                    null: false
    t.string   "media_type",                           null: false
    t.integer  "media_id",                             null: false
    t.integer  "progress"
    t.integer  "rating"
    t.integer  "reconsume_count"
    t.boolean  "reconsuming"
    t.integer  "status"
    t.integer  "volumes_owned"
    t.string   "action_performed",  default: "create", null: false
    t.integer  "sync_status",       default: 0,        null: false
    t.text     "error_message"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "library_entry_logs", ["linked_account_id"], name: "index_library_entry_logs_on_linked_account_id", using: :btree

  create_table "library_events", force: :cascade do |t|
    t.integer  "library_entry_id",              null: false
    t.integer  "user_id",                       null: false
    t.integer  "anime_id"
    t.integer  "manga_id"
    t.integer  "drama_id"
    t.integer  "kind",                          null: false
    t.jsonb    "changed_data",     default: {}, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "library_events", ["anime_id"], name: "index_library_events_on_anime_id", using: :btree
  add_index "library_events", ["drama_id"], name: "index_library_events_on_drama_id", using: :btree
  add_index "library_events", ["manga_id"], name: "index_library_events_on_manga_id", using: :btree
  add_index "library_events", ["user_id"], name: "index_library_events_on_user_id", using: :btree

  create_table "linked_accounts", force: :cascade do |t|
    t.integer  "user_id",                            null: false
    t.string   "external_user_id",                   null: false
    t.boolean  "share_to",           default: false, null: false
    t.boolean  "share_from",         default: false, null: false
    t.string   "encrypted_token"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "encrypted_token_iv"
    t.string   "type",                               null: false
    t.boolean  "sync_to",            default: false, null: false
    t.string   "disabled_reason"
    t.text     "session_data"
  end

  add_index "linked_accounts", ["user_id"], name: "index_linked_accounts_on_user_id", using: :btree

  create_table "list_imports", force: :cascade do |t|
    t.string   "type",                                null: false
    t.integer  "user_id",                             null: false
    t.integer  "strategy",                            null: false
    t.string   "input_file_file_name"
    t.string   "input_file_content_type"
    t.integer  "input_file_file_size"
    t.datetime "input_file_updated_at"
    t.text     "input_text"
    t.integer  "status",                  default: 0, null: false
    t.integer  "progress"
    t.integer  "total"
    t.text     "error_message"
    t.text     "error_trace"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "manga", force: :cascade do |t|
    t.string   "slug",                      limit: 255
    t.text     "synopsis"
    t.string   "poster_image_file_name",    limit: 255
    t.string   "poster_image_content_type", limit: 255
    t.integer  "poster_image_file_size"
    t.datetime "poster_image_updated_at"
    t.string   "cover_image_file_name",     limit: 255
    t.string   "cover_image_content_type",  limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "serialization",             limit: 255
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
    t.integer  "cover_image_top_offset",                                        default: 0
    t.integer  "volume_count"
    t.integer  "chapter_count"
    t.integer  "subtype",                                                       default: 1,       null: false
    t.decimal  "average_rating",                        precision: 5, scale: 2
    t.hstore   "rating_frequencies",                                            default: {},      null: false
    t.hstore   "titles",                                                        default: {},      null: false
    t.string   "canonical_title",                                               default: "en_jp", null: false
    t.string   "abbreviated_titles",                                                                           array: true
    t.integer  "user_count",                                                    default: 0,       null: false
    t.integer  "popularity_rank"
    t.integer  "rating_rank"
    t.integer  "age_rating"
    t.string   "age_rating_guide"
    t.integer  "favorites_count",                                               default: 0,       null: false
    t.boolean  "cover_image_processing"
    t.string   "tba"
    t.integer  "chapter_count_guess"
    t.text     "poster_image_meta"
    t.text     "cover_image_meta"
  end

  create_table "manga_characters", force: :cascade do |t|
    t.integer  "manga_id",                 null: false
    t.integer  "character_id",             null: false
    t.integer  "role",         default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manga_characters", ["character_id"], name: "index_manga_characters_on_character_id", using: :btree
  add_index "manga_characters", ["manga_id", "character_id"], name: "index_manga_characters_on_manga_id_and_character_id", unique: true, using: :btree
  add_index "manga_characters", ["manga_id"], name: "index_manga_characters_on_manga_id", using: :btree

  create_table "manga_media_attributes", force: :cascade do |t|
    t.integer  "manga_id",                       null: false
    t.integer  "media_attribute_id",             null: false
    t.integer  "high_vote_count",    default: 0, null: false
    t.integer  "neutral_vote_count", default: 0, null: false
    t.integer  "low_vote_count",     default: 0, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "manga_media_attributes", ["manga_id", "media_attribute_id"], name: "index_manga_media_attribute", unique: true, using: :btree
  add_index "manga_media_attributes", ["manga_id"], name: "index_manga_media_attributes_on_manga_id", using: :btree
  add_index "manga_media_attributes", ["media_attribute_id"], name: "index_manga_media_attributes_on_media_attribute_id", using: :btree

  create_table "manga_staff", force: :cascade do |t|
    t.integer  "manga_id",   null: false
    t.integer  "person_id",  null: false
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manga_staff", ["manga_id", "person_id"], name: "index_manga_staff_on_manga_id_and_person_id", unique: true, using: :btree
  add_index "manga_staff", ["manga_id"], name: "index_manga_staff_on_manga_id", using: :btree
  add_index "manga_staff", ["person_id"], name: "index_manga_staff_on_person_id", using: :btree

  create_table "mappings", force: :cascade do |t|
    t.string   "external_site", null: false
    t.string   "external_id",   null: false
    t.integer  "item_id",       null: false
    t.string   "item_type",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mappings", ["external_site", "external_id", "item_type", "item_id"], name: "index_mappings_on_external_and_item", unique: true, using: :btree

  create_table "media_attribute_votes", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.integer  "anime_media_attributes_id"
    t.integer  "manga_media_attributes_id"
    t.integer  "dramas_media_attributes_id"
    t.integer  "media_id",                   null: false
    t.string   "media_type",                 null: false
    t.integer  "vote",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "media_attribute_votes", ["user_id", "media_id", "media_type"], name: "index_user_media_on_media_attr_votes", unique: true, using: :btree
  add_index "media_attribute_votes", ["user_id"], name: "index_media_attribute_votes_on_user_id", using: :btree

  create_table "media_attributes", force: :cascade do |t|
    t.string   "title",         null: false
    t.string   "high_title",    null: false
    t.string   "neutral_title", null: false
    t.string   "low_title",     null: false
    t.string   "slug",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "media_attributes", ["slug"], name: "index_media_attributes_on_slug", using: :btree
  add_index "media_attributes", ["title"], name: "index_media_attributes_on_title", using: :btree

  create_table "media_ignores", force: :cascade do |t|
    t.integer  "media_id"
    t.string   "media_type"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "media_ignores", ["media_type", "media_id"], name: "index_media_ignores_on_media_type_and_media_id", using: :btree
  add_index "media_ignores", ["user_id"], name: "index_media_ignores_on_user_id", using: :btree

  create_table "media_reaction_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_reaction_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "media_reaction_votes", ["media_reaction_id", "user_id"], name: "index_media_reaction_votes_on_media_reaction_id_and_user_id", unique: true, using: :btree
  add_index "media_reaction_votes", ["media_reaction_id"], name: "index_media_reaction_votes_on_media_reaction_id", using: :btree
  add_index "media_reaction_votes", ["user_id"], name: "index_media_reaction_votes_on_user_id", using: :btree

  create_table "media_reactions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_id",                                 null: false
    t.string   "media_type",                               null: false
    t.integer  "anime_id"
    t.integer  "manga_id"
    t.integer  "drama_id"
    t.integer  "library_entry_id"
    t.integer  "up_votes_count",               default: 0, null: false
    t.integer  "progress",                     default: 0, null: false
    t.string   "reaction",         limit: 140
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "deleted_at"
  end

  add_index "media_reactions", ["anime_id"], name: "index_media_reactions_on_anime_id", using: :btree
  add_index "media_reactions", ["deleted_at"], name: "index_media_reactions_on_deleted_at", using: :btree
  add_index "media_reactions", ["drama_id"], name: "index_media_reactions_on_drama_id", using: :btree
  add_index "media_reactions", ["library_entry_id"], name: "index_media_reactions_on_library_entry_id", using: :btree
  add_index "media_reactions", ["manga_id"], name: "index_media_reactions_on_manga_id", using: :btree
  add_index "media_reactions", ["media_type", "media_id", "user_id"], name: "index_media_reactions_on_media_type_and_media_id_and_user_id", unique: true, where: "(deleted_at IS NULL)", using: :btree
  add_index "media_reactions", ["user_id"], name: "index_media_reactions_on_user_id", using: :btree

  create_table "media_relationships", force: :cascade do |t|
    t.integer  "source_id",        null: false
    t.string   "source_type",      null: false
    t.integer  "destination_id",   null: false
    t.string   "destination_type", null: false
    t.integer  "role",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media_relationships", ["source_type", "source_id"], name: "index_media_relationships_on_source_type_and_source_id", using: :btree

  create_table "not_interesteds", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "media_id"
    t.string   "media_type", limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "not_interesteds", ["user_id"], name: "index_not_interesteds_on_user_id", using: :btree

  create_table "notification_settings", force: :cascade do |t|
    t.integer  "setting_type",                        null: false
    t.integer  "user_id",                             null: false
    t.boolean  "email_enabled",        default: true
    t.boolean  "web_enabled",          default: true
    t.boolean  "mobile_enabled",       default: true
    t.boolean  "fb_messenger_enabled", default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "notification_settings", ["user_id"], name: "index_notification_settings_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "source_id"
    t.string   "source_type",       limit: 255
    t.hstore   "data"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "notification_type", limit: 255
    t.boolean  "seen",                          default: false
  end

  add_index "notifications", ["source_id"], name: "index_notifications_on_source_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "oauth_applications", ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "one_signal_players", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "player_id"
    t.integer  "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "one_signal_players", ["user_id"], name: "index_one_signal_players_on_user_id", using: :btree

  create_table "partner_codes", force: :cascade do |t|
    t.integer  "partner_deal_id",             null: false
    t.string   "code",            limit: 255, null: false
    t.integer  "user_id"
    t.datetime "expires_at"
    t.datetime "claimed_at"
  end

  add_index "partner_codes", ["partner_deal_id", "user_id"], name: "index_partner_codes_on_partner_deal_id_and_user_id", using: :btree

  create_table "partner_deals", force: :cascade do |t|
    t.string   "deal_title",                limit: 255,                null: false
    t.string   "partner_name",              limit: 255,                null: false
    t.string   "valid_countries",           limit: 255, default: [],   null: false, array: true
    t.string   "partner_logo_file_name",    limit: 255
    t.string   "partner_logo_content_type", limit: 255
    t.integer  "partner_logo_file_size"
    t.datetime "partner_logo_updated_at"
    t.text     "deal_url",                                             null: false
    t.text     "deal_description",                                     null: false
    t.text     "redemption_info",                                      null: false
    t.boolean  "active",                                default: true, null: false
    t.integer  "recurring",                             default: 0
  end

  add_index "partner_deals", ["valid_countries"], name: "index_partner_deals_on_valid_countries", using: :gin

  create_table "people", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "mal_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "people", ["mal_id"], name: "index_people_on_mal_id", unique: true, using: :btree
  add_index "people", ["mal_id"], name: "person_mal_id", unique: true, using: :btree

  create_table "post_follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "post_id"
  end

  add_index "post_follows", ["post_id"], name: "index_post_follows_on_post_id", using: :btree
  add_index "post_follows", ["user_id"], name: "index_post_follows_on_user_id", using: :btree

  create_table "post_likes", force: :cascade do |t|
    t.integer  "post_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "post_likes", ["post_id"], name: "index_post_likes_on_post_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",                                  null: false
    t.integer  "target_user_id"
    t.text     "content"
    t.text     "content_formatted"
    t.integer  "media_id"
    t.string   "media_type"
    t.boolean  "spoiler",                  default: false, null: false
    t.boolean  "nsfw",                     default: false, null: false
    t.boolean  "blocked",                  default: false, null: false
    t.integer  "spoiled_unit_id"
    t.string   "spoiled_unit_type"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.datetime "deleted_at"
    t.integer  "target_group_id"
    t.integer  "post_likes_count",         default: 0,     null: false
    t.integer  "comments_count",           default: 0,     null: false
    t.integer  "top_level_comments_count", default: 0,     null: false
    t.datetime "edited_at"
    t.string   "target_interest"
    t.jsonb    "embed"
    t.integer  "community_recommendation_id"
  end

  add_index "posts", ["community_recommendation_id"], name: "index_posts_on_community_recommendation_id", using: :btree
  add_index "posts", ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree
  add_index "posts", ["media_type", "media_id"], name: "posts_media_type_media_id_idx", using: :btree

  create_table "pro_membership_plans", force: :cascade do |t|
    t.string   "name",                       null: false
    t.integer  "amount",                     null: false
    t.integer  "duration",                   null: false
    t.boolean  "recurring",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "producers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "profile_link_sites", force: :cascade do |t|
    t.string   "name",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "validate_find"
    t.string   "validate_replace"
  end

  create_table "profile_links", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "profile_link_site_id", null: false
    t.string   "url",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profile_links", ["profile_link_site_id"], name: "index_profile_links_on_profile_link_site_id", using: :btree
  add_index "profile_links", ["user_id", "profile_link_site_id"], name: "index_profile_links_on_user_id_and_profile_link_site_id", unique: true, using: :btree
  add_index "profile_links", ["user_id"], name: "index_profile_links_on_user_id", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.integer  "anime_id"
    t.text     "content"
    t.string   "character_name", limit: 255
    t.integer  "user_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "positive_votes",             default: 0, null: false
  end

  add_index "quotes", ["anime_id"], name: "index_quotes_on_anime_id", using: :btree

  create_table "rails_admin_histories", force: :cascade do |t|
    t.text     "message"
    t.string   "username",   limit: 255
    t.integer  "item"
    t.string   "table",      limit: 255
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.hstore   "recommendations"
  end

  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "naughty_id",               null: false
    t.string   "naughty_type",             null: false
    t.integer  "reason",                   null: false
    t.text     "explanation"
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "status",       default: 0, null: false
    t.integer  "moderator_id"
  end

  add_index "reports", ["naughty_id", "user_id"], name: "index_reports_on_naughty_id_and_user_id", unique: true, using: :btree
  add_index "reports", ["naughty_type", "naughty_id"], name: "index_reports_on_naughty_type_and_naughty_id", using: :btree
  add_index "reports", ["status"], name: "index_reports_on_status", using: :btree

  create_table "reposts", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "post_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reposts", ["post_id"], name: "index_reposts_on_post_id", using: :btree
  add_index "reposts", ["user_id"], name: "index_reposts_on_user_id", using: :btree

  create_table "review_likes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "review_id",  null: false
    t.integer  "user_id",    null: false
  end

  add_index "review_likes", ["review_id"], name: "index_review_likes_on_review_id", using: :btree
  add_index "review_likes", ["user_id"], name: "index_review_likes_on_user_id", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id",                                       null: false
    t.integer  "media_id",                                      null: false
    t.text     "content",                                       null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.float    "rating",                                        null: false
    t.string   "source",            limit: 255
    t.integer  "likes_count",                   default: 0
    t.string   "media_type"
    t.text     "content_formatted",                             null: false
    t.integer  "library_entry_id"
    t.integer  "progress"
    t.boolean  "spoiler",                       default: false, null: false
    t.datetime "deleted_at"
  end

  add_index "reviews", ["deleted_at"], name: "index_reviews_on_deleted_at", using: :btree
  add_index "reviews", ["likes_count"], name: "index_reviews_on_likes_count", using: :btree
  add_index "reviews", ["media_id"], name: "index_reviews_on_media_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "site_announcements", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.text     "description"
    t.string   "link"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title",       null: false
    t.string   "image_url"
  end

  create_table "stats", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.string   "type",                    null: false
    t.jsonb    "stats_data", default: {}, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "stats", ["type", "user_id"], name: "index_stats_on_type_and_user_id", unique: true, using: :btree
  add_index "stats", ["user_id"], name: "index_stats_on_user_id", using: :btree

  create_table "stories", force: :cascade do |t|
    t.integer  "user_id"
    t.hstore   "data"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "story_type",       limit: 255
    t.integer  "target_id"
    t.string   "target_type",      limit: 255
    t.integer  "library_entry_id"
    t.boolean  "adult",                        default: false
    t.integer  "total_votes",                  default: 0,     null: false
    t.integer  "group_id"
    t.datetime "deleted_at"
  end

  add_index "stories", ["created_at"], name: "index_stories_on_created_at", using: :btree
  add_index "stories", ["deleted_at"], name: "index_stories_on_deleted_at", using: :btree
  add_index "stories", ["group_id"], name: "index_stories_on_group_id", using: :btree
  add_index "stories", ["user_id"], name: "index_stories_on_user_id", using: :btree

  create_table "streamers", force: :cascade do |t|
    t.string   "site_name",             limit: 255,             null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "streaming_links_count",             default: 0, null: false
  end

  create_table "streaming_links", force: :cascade do |t|
    t.integer  "media_id",                     null: false
    t.string   "media_type",                   null: false
    t.integer  "streamer_id",                  null: false
    t.string   "url",                          null: false
    t.string   "subs",        default: ["en"], null: false, array: true
    t.string   "dubs",        default: ["ja"], null: false, array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "streaming_links", ["media_type", "media_id"], name: "index_streaming_links_on_media_type_and_media_id", using: :btree
  add_index "streaming_links", ["streamer_id"], name: "index_streaming_links_on_streamer_id", using: :btree

  create_table "substories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "story_id"
    t.integer  "target_id"
    t.string   "target_type",   limit: 255
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.hstore   "data"
    t.integer  "substory_type",             default: 0, null: false
    t.datetime "deleted_at"
  end

  add_index "substories", ["created_at"], name: "index_substories_on_created_at", using: :btree
  add_index "substories", ["deleted_at"], name: "index_substories_on_deleted_at", using: :btree
  add_index "substories", ["story_id"], name: "index_substories_on_story_id", using: :btree
  add_index "substories", ["target_id"], name: "index_substories_on_target_id", using: :btree
  add_index "substories", ["user_id"], name: "index_substories_on_user_id", using: :btree

  create_table "uploads", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "user_id",              null: false
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "content_updated_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "upload_order"
    t.text     "content_meta"
  end

  add_index "uploads", ["owner_type", "owner_id"], name: "index_uploads_on_owner_type_and_owner_id", using: :btree
  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree

  create_table "user_ip_addresses", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.inet     "ip_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_ip_addresses", ["ip_address", "user_id"], name: "index_user_ip_addresses_on_ip_address_and_user_id", unique: true, using: :btree
  add_index "user_ip_addresses", ["user_id"], name: "index_user_ip_addresses_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                       limit: 255, default: ""
    t.string   "name",                        limit: 255
    t.string   "password_digest",             limit: 255, default: ""
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.boolean  "recommendations_up_to_date"
    t.string   "avatar_file_name",            limit: 255
    t.string   "avatar_content_type",         limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "facebook_id",                 limit: 255
    t.string   "bio",                         limit: 140, default: "",          null: false
    t.boolean  "sfw_filter",                              default: true
    t.string   "mal_username",                limit: 255
    t.integer  "life_spent_on_anime",                     default: 0,           null: false
    t.string   "about",                       limit: 500, default: "",          null: false
    t.datetime "confirmed_at"
    t.string   "cover_image_file_name",       limit: 255
    t.string   "cover_image_content_type",    limit: 255
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "title_language_preference",   limit: 255, default: "canonical"
    t.integer  "followers_count",                         default: 0
    t.integer  "following_count",                         default: 0
    t.boolean  "ninja_banned",                            default: false
    t.datetime "last_recommendations_update"
    t.boolean  "avatar_processing"
    t.boolean  "subscribed_to_newsletter",                default: true
    t.string   "location",                    limit: 255
    t.string   "waifu_or_husbando",           limit: 255
    t.integer  "waifu_id"
    t.boolean  "to_follow",                               default: false
    t.string   "dropbox_token",               limit: 255
    t.string   "dropbox_secret",              limit: 255
    t.datetime "last_backup"
    t.integer  "approved_edit_count",                     default: 0
    t.integer  "rejected_edit_count",                     default: 0
    t.datetime "pro_expires_at"
    t.string   "stripe_token",                limit: 255
    t.integer  "pro_membership_plan_id"
    t.string   "stripe_customer_id",          limit: 255
    t.text     "about_formatted"
    t.integer  "import_status"
    t.string   "import_from",                 limit: 255
    t.string   "import_error",                limit: 255
    t.string   "past_names",                              default: [],          null: false, array: true
    t.string   "gender"
    t.date     "birthday"
    t.string   "twitter_id"
    t.integer  "comments_count",                          default: 0,           null: false
    t.integer  "likes_given_count",                       default: 0,           null: false
    t.integer  "likes_received_count",                    default: 0,           null: false
    t.integer  "favorites_count",                         default: 0,           null: false
    t.integer  "posts_count",                             default: 0,           null: false
    t.integer  "ratings_count",                           default: 0,           null: false
    t.integer  "reviews_count",                           default: 0,           null: false
    t.string   "previous_email"
    t.integer  "pinned_post_id"
    t.string   "time_zone"
    t.string   "language"
    t.string   "country",                     limit: 2
    t.boolean  "share_to_global",                         default: true,        null: false
    t.string   "title"
    t.boolean  "profile_completed",                       default: false,       null: false
    t.boolean  "feed_completed",                          default: false,       null: false
    t.boolean  "cover_image_processing"
    t.integer  "rating_system",                           default: 0,           null: false
    t.integer  "theme",                                   default: 0,           null: false
    t.datetime "deleted_at"
    t.integer  "media_reactions_count",                   default: 0,           null: false
    t.integer  "status",                                  default: 1,           null: false
    t.text     "avatar_meta"
    t.text     "cover_image_meta"
    t.citext   "slug"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["facebook_id"], name: "index_users_on_facebook_id", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  add_index "users", ["to_follow"], name: "index_users_on_to_follow", using: :btree
  add_index "users", ["waifu_id"], name: "index_users_on_waifu_id", using: :btree

  create_table "users_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "item_id",                                null: false
    t.string   "item_type",      limit: 255,             null: false
    t.integer  "user_id"
    t.json     "object",                                 null: false
    t.json     "object_changes",                         null: false
    t.integer  "state",                      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment",        limit: 255
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["user_id"], name: "index_versions_on_user_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "url",               limit: 255,                  null: false
    t.jsonb    "embed_data",                    default: {},     null: false
    t.string   "available_regions", limit: 255, default: ["US"],              array: true
    t.integer  "episode_id",                                     null: false
    t.integer  "streamer_id",                                    null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "sub_lang",          limit: 255
    t.string   "dub_lang",          limit: 255
  end

  add_index "videos", ["available_regions"], name: "index_videos_on_available_regions", using: :gin
  add_index "videos", ["dub_lang"], name: "index_videos_on_dub_lang", using: :btree
  add_index "videos", ["episode_id"], name: "index_videos_on_episode_id", using: :btree
  add_index "videos", ["streamer_id"], name: "index_videos_on_streamer_id", using: :btree
  add_index "videos", ["sub_lang"], name: "index_videos_on_sub_lang", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "target_id",                              null: false
    t.string   "target_type", limit: 255,                null: false
    t.integer  "user_id",                                null: false
    t.boolean  "positive",                default: true, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "votes", ["target_id", "target_type", "user_id"], name: "index_votes_on_target_id_and_target_type_and_user_id", unique: true, using: :btree
  add_index "votes", ["user_id", "target_type"], name: "index_votes_on_user_id_and_target_type", using: :btree

  add_foreign_key "ama_subscribers", "amas"
  add_foreign_key "ama_subscribers", "users"
  add_foreign_key "amas", "posts", column: "original_post_id"
  add_foreign_key "amas", "users", column: "author_id"
  add_foreign_key "anime_castings", "anime_characters"
  add_foreign_key "anime_castings", "people"
  add_foreign_key "anime_castings", "producers", column: "licensor_id"
  add_foreign_key "anime_characters", "anime"
  add_foreign_key "anime_characters", "characters"
  add_foreign_key "anime_media_attributes", "anime"
  add_foreign_key "anime_media_attributes", "media_attributes"
  add_foreign_key "anime_staff", "anime"
  add_foreign_key "anime_staff", "people"
  add_foreign_key "blocks", "users"
  add_foreign_key "blocks", "users", column: "blocked_id"
  add_foreign_key "category_favorites", "categories"
  add_foreign_key "category_favorites", "users"
  add_foreign_key "comment_likes", "comments"
  add_foreign_key "comment_likes", "users"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "community_recommendation_follows", "community_recommendation_requests"
  add_foreign_key "community_recommendation_follows", "users"
  add_foreign_key "community_recommendation_requests", "users"
  add_foreign_key "community_recommendations", "anime"
  add_foreign_key "community_recommendations", "community_recommendation_requests"
  add_foreign_key "community_recommendations", "dramas"
  add_foreign_key "community_recommendations", "manga"
  add_foreign_key "drama_castings", "drama_characters"
  add_foreign_key "drama_castings", "people"
  add_foreign_key "drama_castings", "producers", column: "licensor_id"
  add_foreign_key "drama_characters", "characters"
  add_foreign_key "drama_characters", "dramas"
  add_foreign_key "drama_staff", "dramas"
  add_foreign_key "drama_staff", "people"
  add_foreign_key "dramas_media_attributes", "dramas"
  add_foreign_key "dramas_media_attributes", "media_attributes"
  add_foreign_key "group_action_logs", "groups"
  add_foreign_key "group_action_logs", "users"
  add_foreign_key "group_bans", "groups"
  add_foreign_key "group_bans", "users"
  add_foreign_key "group_bans", "users", column: "moderator_id"
  add_foreign_key "group_invites", "groups"
  add_foreign_key "group_invites", "users"
  add_foreign_key "group_invites", "users", column: "sender_id"
  add_foreign_key "group_member_notes", "group_members"
  add_foreign_key "group_member_notes", "users"
  add_foreign_key "group_neighbors", "groups", column: "destination_id"
  add_foreign_key "group_neighbors", "groups", column: "source_id"
  add_foreign_key "group_permissions", "group_members"
  add_foreign_key "group_reports", "groups"
  add_foreign_key "group_reports", "users"
  add_foreign_key "group_reports", "users", column: "moderator_id"
  add_foreign_key "group_ticket_messages", "group_tickets", column: "ticket_id"
  add_foreign_key "group_tickets", "group_ticket_messages", column: "first_message_id"
  add_foreign_key "group_tickets", "groups"
  add_foreign_key "group_tickets", "users"
  add_foreign_key "group_tickets", "users", column: "assignee_id"
  add_foreign_key "groups", "group_categories", column: "category_id"
  add_foreign_key "groups", "posts", column: "pinned_post_id"
  add_foreign_key "leader_chat_messages", "groups"
  add_foreign_key "leader_chat_messages", "users"
  add_foreign_key "library_entries", "media_reactions"
  add_foreign_key "library_events", "library_entries"
  add_foreign_key "library_events", "users"
  add_foreign_key "linked_accounts", "users"
  add_foreign_key "manga_characters", "characters"
  add_foreign_key "manga_characters", "manga"
  add_foreign_key "manga_media_attributes", "manga"
  add_foreign_key "manga_media_attributes", "media_attributes"
  add_foreign_key "manga_staff", "manga"
  add_foreign_key "manga_staff", "people"
  add_foreign_key "media_attribute_votes", "users"
  add_foreign_key "media_ignores", "users"
  add_foreign_key "media_reaction_votes", "media_reactions"
  add_foreign_key "media_reaction_votes", "users"
  add_foreign_key "media_reactions", "anime"
  add_foreign_key "media_reactions", "dramas"
  add_foreign_key "media_reactions", "library_entries"
  add_foreign_key "media_reactions", "manga"
  add_foreign_key "media_reactions", "users"
  add_foreign_key "notification_settings", "users"
  add_foreign_key "one_signal_players", "users"
  add_foreign_key "post_follows", "posts"
  add_foreign_key "post_follows", "users"
  add_foreign_key "posts", "community_recommendations"
  add_foreign_key "posts", "users"
  add_foreign_key "posts", "users", column: "target_user_id"
  add_foreign_key "profile_links", "profile_link_sites"
  add_foreign_key "profile_links", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "reports", "users", column: "moderator_id"
  add_foreign_key "reposts", "posts"
  add_foreign_key "reposts", "users"
  add_foreign_key "review_likes", "users"
  add_foreign_key "reviews", "library_entries"
  add_foreign_key "site_announcements", "users"
  add_foreign_key "stats", "users"
  add_foreign_key "streaming_links", "streamers"
  add_foreign_key "uploads", "users"
  add_foreign_key "user_ip_addresses", "users"
  add_foreign_key "users", "posts", column: "pinned_post_id"
end
