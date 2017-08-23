# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: mappings
#
#  id            :integer          not null, primary key
#  external_site :string           not null, indexed => [external_id, item_type, item_id]
#  item_type     :string           not null, indexed => [external_site, external_id, item_id]
#  created_at    :datetime
#  updated_at    :datetime
#  external_id   :string           not null, indexed => [external_site, item_type, item_id]
#  item_id       :integer          not null, indexed => [external_site, external_id, item_type]
#
# Indexes
#
#  index_mappings_on_external_and_item  (external_site,external_id,item_type,item_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

class Mapping < ApplicationRecord
  belongs_to :item, polymorphic: true, required: true

  validates :external_site, :external_id, presence: true
  # Right now, we want to ensure only one external id per item per site
  validates :item_id, uniqueness: { scope: %i[item_type external_site] }

  def self.lookup(site, id)
    find_by(external_site: site, external_id: id).try(:item)
  end

  def self.guess_algolia(type, query)
    Algolia.init application_id: ENV['ALGOLIA_APP_ID'], api_key: ENV['ALGOLIA_SEARCH_KEY']
    AlgoliaMediaIndex.search(query, type.constantize).first
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
