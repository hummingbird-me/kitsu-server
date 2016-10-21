class FeedsController < ApplicationController
  include Pundit

  def show
    serializer = FeedSerializerService.new(activity_list, including: including,
                                           fields: fields, context: context)
    render json: serializer
  end

  private

  def feed
    @feed ||= Feed.new(params[:group], params[:id])
  end

  def activity_list
    # TODO: add pagination
    @feed_data ||= feed.activities
  end

  def including
    params[:include]&.split(',')
  end

  def fields
    params[:fields]&.split(',')
  end
end
