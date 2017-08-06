class UploadsController < ApplicationController
  include CustomControllerHelpers
  before_action :authenticate_user!

  def bulk_create
    files_to_upload = params[:files].map { |file| { user: user, content: file } }
    uploads = Upload.create(files_to_upload)
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
