class FeedsController < ApplicationController
  include Pundit
  skip_after_action :enforce_policy_use

  def show
    serializer = FeedSerializerService.new(activity_list, including: including,
                                           fields: fields, context: context,
                                           base_url: request.url)
    render json: serializer
  end

  private

  def feed
    @feed ||= Feed.new(params[:group], params[:id])
  end

  def activity_list
    @feed_data ||= paginate(feed.activities)
  end

  def paginate(list)
    if params.dig(:page, :cursor)
      cursor = params.dig(:page, :cursor)
      limit = params.dig(:page, :limit).to_i
      list = list.page(id_lt: cursor)
      list = list.limit(limit) if limit
      list
    else
      activity_list
    end
  end

  def including
    params[:include]&.split(',')
  end

  def fields
    params[:fields]&.split(',')
  end
end
