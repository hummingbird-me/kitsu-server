# frozen_string_literal: true

class ListImport
  class Anilist < ListImport
    # accepts a username as input
    validates :input_text, length: {
      minimum: 3,
      maximum: 20
    }, presence: true
    # does not accept file uploads
    validates :input_file_data, absence: true
    validate :ensure_user_exists, on: :create

    def ensure_user_exists
      return false if input_text.blank?
      return true if user_exists?

      errors.add(:input_text, "AniList user not found - #{input_text}")
    end

    def count
      @count ||= anime_list.count + manga_list.count
    end

    def each
      %w[anime manga].each do |type|
        send("#{type}_list").each do |media|
          row = Row.new(media, type)

          yield row.media, row.data
        end
      end
    end

    private

    def anime_list
      media_lists.data.anime.lists.map(&:entries).flatten
    end

    def manga_list
      media_lists.data.manga.lists.map(&:entries).flatten
    end

    def user_exists?
      @user_exists ||= media_lists&.errors&.detect { |error| error.last.include?('404') }.blank?
    end

    def media_lists
      @media_lists ||= AnilistApiWrapper::Client.query(
        MEDIA_LIST_QUERY,
        variables: {
          user_name: input_text
        }
      )
    end

    begin
      MEDIA_LIST_QUERY = AnilistApiWrapper::Client.parse <<-'GRAPHQL'
        query($user_name: String) {
          anime: MediaListCollection(userName: $user_name, type: ANIME) {
            lists {
              name
              entries {
                score(format: POINT_100)
                status
                repeat
                progress
                progressVolumes
                notes
                startedAt {
                  year
                  month
                  day
                }
                completedAt {
                  year
                  month
                  day
                }
                media {
                  id
                  idMal
                  episodes
                  chapters
                  title {
                    romaji
                    english
                    native
                    userPreferred
                  }
                }
              }
            }
          },
          manga: MediaListCollection(userName: $user_name, type: MANGA) {
            lists {
              name
              entries {
                score(format: POINT_100)
                status
                repeat
                progress
                progressVolumes
                notes
                startedAt {
                  year
                  month
                  day
                }
                completedAt {
                  year
                  month
                  day
                }
                media {
                  id
                  idMal
                  episodes
                  chapters
                  title {
                    romaji
                    english
                    native
                    userPreferred
                  }
                }
              }
            }
          }
        }
      GRAPHQL
    end
  rescue StandardError => e
    Raven.capture_exception(e)
  end
end
