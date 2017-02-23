# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null, indexed => [external_id, media_type, media_id]
#  media_type    :string           not null, indexed => [external_site, external_id, media_id]
#  external_id   :string           not null, indexed => [external_site, media_type, media_id]
#  media_id      :integer          not null, indexed => [external_site, external_id, media_type]
#
# Indexes
#
#  index_mappings_on_external_and_media  (external_site,external_id,media_type,media_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

class Mapping < ApplicationRecord
  has_paper_trail
  belongs_to :media, polymorphic: true, required: true

  validates :external_site, :external_id, presence: true
  # Right now, we want to ensure only one external id per media per site
  validates :media_id, uniqueness: { scope: %i[media_type external_site] }
  validates :media, polymorphism: { type: Media }

  def self.lookup(site, id)
    find_by(external_site: site, external_id: id).try(:media)
  end

  def self.guess(type, info)
    results = "MediaIndex::#{type}".constantize.query(
      function_score: {
        script_score: {
          lang: 'expression',
          script: "max(log10(doc['user_count'].value), 1) * _score",
        },
        query: {
          bool: {
            should: [
              { multi_match: {
                fields: %w[titles.* abbreviated_titles],
                query: info[:title],
                fuzziness: 3,
                max_expansions: 15,
                prefix_length: 2
              } },
              { multi_match: {
                fields: %w[titles.* abbreviated_titles],
                query: info[:title],
                boost: 1.2,
              } },
              ({ match: {
                subtype: info[:subtype]
              } } if info[:subtype].present?),
              ({ fuzzy: {
                episode_count: {
                  value: info[:episode_count],
                  fuzziness: 2
                }
              } } if info[:episode_count].present?),
              ({ fuzzy: {
                episode_count: {
                  value: info[:chapter_count],
                  fuzziness: 2
                }
              } } if info[:chapter_count].present?)
            ].compact
          }
        }
      }
    )
    score = results.first&._score
    top_result = results.load.first
    # If we only get one result, or the top result has a good score, pick it
    top_result if top_result && score > 5 || results.count == 1
    # Otherwise nil
  end
end
