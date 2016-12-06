class FeedsController < ApplicationController
  include Skylight::Helpers
  include Pundit
  skip_after_action :enforce_policy_use

  def show
    render json: stringify_activities(query.list)
  end

  def mark_read
    activities = feed.activities.mark(:read, params[:_json])
    render json: serialize_activities(activities)
  end

  def mark_seen
    activities = feed.activities.mark(:seen, params[:_json])
    render json: serialize_activities(activities)
  end

  private

  def serialize_activities(list)
    @serializer ||= FeedSerializerService.new(
      list,
      including: params[:include]&.split(','),
      fields: params[:fields]&.split(','),
      context: context,
      base_url: request.url
    )
  end

  instrument_method
  def stringify_activities(list)
    Oj.dump(serialize_activities(list))
  end

  def query
    @query ||= FeedQueryService.new(params, current_user&.resource_owner)
  end

  delegate :feed, to: :query
end
