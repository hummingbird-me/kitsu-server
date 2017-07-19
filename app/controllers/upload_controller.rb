class UploadController < ApplicationController
  include CustomControllerHelpers
  before_action :authenticate_user!

  def bulk_create
    files_to_upload = params[:files].map { |file| {user: user, content: file} }
    uploads = Upload.create(files_to_upload)
    render json: serialize_entries(uploads)
  end

  def update
    upload = Upload.find(id: params[:upload_id], user: user)
    unless upload
      render_jsonapi serialize_error(401, 'Not permitted'), status: 401
    end

    if params.has_key?(:post)
      upload.post = params[:post]
    elsif params.has_key?(:comment)
      upload.comment = params[:comment]
    else
      render_jsonapi serialize_error(400, 'Needs related post or comment field'), status: 400
    end
    upload.save
    render json: serializer.serialize_to_hash(UploadResource.new(upload, context))
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
