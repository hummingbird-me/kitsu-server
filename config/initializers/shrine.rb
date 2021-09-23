require 'shrine/storage/s3'

Shrine.plugin :activerecord
Shrine.plugin :pretty_location
# We upload in the most cursed fashion
Shrine.plugin :data_uri
# MIME is Hard
Shrine.plugin :determine_mime_type, analyzer: :marcel
Shrine.plugin :infer_extension
# Handle derivatives in background
Shrine.plugin :derivatives
Shrine.plugin :backgrounding
Shrine.plugin :url_options, store: { host: 'https://media.kitsu.io' }

s3_options = {
  endpoint: ENV['AWS_ENDPOINT'] || nil,
  bucket: ENV['AWS_BUCKET'] || 'kitsu-media',
  force_path_style: true,
  region: 'us-east-1'
}.compact

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}

Shrine::Attacher.promote_block do |attacher|
  attacher.atomic_promote
  ShrineDerivativeWorker.perform_async(attacher)
end
