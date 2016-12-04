class FeedsController < ApplicationController
  include Pundit
  skip_after_action :enforce_policy_use

  def show
    render json: serialize_activities(activity_list)
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
    FeedSerializerService.new(list, including: including, fields: fields,
                              context: context, base_url: request.url,
                              sfw_filter: sfw_filter?, blocking: blocked)
  end

  def sfw_filter?
    current_user&.resource_owner&.sfw_filter?
  end

  def feed
    @feed ||= Feed.new(params[:group], params[:id])
  end

  def activity_list
    @feed_data ||= auto_mark(filter_id(paginate(feed.activities)))
  end

  def paginate(list)
    cursor = params.dig(:page, :cursor)
    limit = params.dig(:page, :limit)&.to_i
    list = list.page(id_lt: cursor) if cursor
    list = list.limit(limit) if limit
    list
  end

  def filter_id(list)
    list = list.where_id(*id_query) if id_query
    list
  end

  def auto_mark(list)
    list = list.mark(params[:mark]) if params.include? :mark
    list
  end

  def including
    params[:include]&.split(',')
  end

  def fields
    params[:fields]&.split(',')
  end

  def id_query
    return unless params.dig(:filter, :id).is_a? Hash
    operator, id = params.dig(:filter, :id).to_a.flatten
    [operator.to_sym, id]
  end

  def blocked
    Block.hidden_for(current_user&.resource_owner)
  end
end
