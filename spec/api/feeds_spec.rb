# frozen_string_literal: true

require 'rails_helper'

# Runs a feed read through the whole glue: FeedsController -> FeedQueryService -> Stream client ->
# enrichment -> FeedSerializerService, with only Stream's HTTP API stubbed.
RSpec.describe 'Feeds' do
  let(:user) { create(:user) }
  let(:anime) { create(:anime) }
  let(:feed_post) { create(:post, user:, media: anime) }
  let(:activity_id) { SecureRandom.uuid }
  let(:time) { '2026-01-01T00:00:00.000000' }
  let(:stream_response) do
    {
      results: [{
        id: SecureRandom.uuid, group: "post_#{feed_post.id}", verb: 'post',
        activity_count: 1, actor_count: 1, created_at: time, updated_at: time,
        activities: [{
          id: activity_id, actor: "User:#{user.id}", verb: 'post', object: "Post:#{feed_post.id}",
          foreign_id: "Post:#{feed_post.id}", time:, post_id: feed_post.id, nsfw: false
        }]
      }],
      next: ''
    }
  end

  before do
    stub_request(:get, %r{/api/v1\.0/feed/media_aggr/Anime-#{anime.id}/})
      .to_return(body: stream_response.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'serializes an aggregated feed with its enriched activities' do
    get "/api/edge/feeds/media_aggr/Anime-#{anime.id}", params: { include: 'actor,subject' }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['data'].pluck('type')).to eq(['activityGroups'])
    expect(json['included'].map { |res| res.values_at('type', 'id') }).to include(
      ['activities', activity_id],
      ['users', user.id.to_s],
      ['posts', feed_post.id.to_s]
    )
    activity = json['included'].find { |res| res['type'] == 'activities' }
    expect(activity.dig('relationships', 'subject', 'data')).to eq(
      'type' => 'posts', 'id' => feed_post.id.to_s
    )
    expect(json.dig('meta', 'feed')).to include(
      'group' => 'media_aggr', 'id' => "Anime-#{anime.id}"
    )
  end

  it 'refuses feeds the requester may not see' do
    get "/api/edge/feeds/timeline/#{user.id}"

    expect(response).to have_http_status(:forbidden)
  end
end
