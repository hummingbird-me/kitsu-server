class UploadsController < ApplicationController
  include CustomControllerHelpers
  before_action :authenticate_user!, only: :bulk_create

  def bulk_create
    files_to_upload = params[:files].map do |file|
      stripped_file = ImageProcessing::MiniMagick.source(file).saver(strip: true).call
      { user: user, content: stripped_file }
    end
    uploads = Upload.create!(files_to_upload)
    render json: serialize_entries(uploads)
  end

  private

  def serialize_entries(entries)
    serializer.serialize_to_hash(wrap_in_resources(entries))
  end

  def wrap_in_resources(entries)
    entries.map { |entry| UploadResource.new(entry, context) }
  end

  def serializer
    JSONAPI::ResourceSerializer.new(UploadResource)
  end
end
