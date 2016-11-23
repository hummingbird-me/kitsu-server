class FeedsController < ApplicationController
  include Pundit
  skip_after_action :enforce_policy_use

  def show
    serializer = FeedSerializerService.new(page, including: including,
                                           fields: fields, context: context,
                                           base_url: request.url)
    render json: serializer
  end

  private

  def feed
    @feed ||= Feed.new(params[:group], params[:id])
  end

  def activity_list
    @feed_data ||= feed.activities
  end

  def page
    if params.dig(:page, :cursor)
      @page ||= activity_list.page(id_lt: params.dig(:page, :cursor))
    else
      @page ||= activity_list
    end
  end

  def including
    params[:include]&.split(',')
  end

  def fields
    params[:fields]&.split(',')
  end
end
