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

if Rails.env.production? || Rails.env.staging?
  # Primary storage
  backblaze = Shrine::Storage::S3.new(
    endpoint: 'https://s3.us-west-002.backblazeb2.com',
    region: 'us-west-002',
    bucket: ENV.fetch('B2_BUCKET', nil),
    access_key_id: ENV.fetch('B2_ACCESS_KEY_ID', nil),
    secret_access_key: ENV.fetch('B2_SECRET_ACCESS_KEY', nil)
  )

  # Temporary upload storage
  cache = Shrine::Storage::S3.new(
    endpoint: 'https://s3.us-west-002.backblazeb2.com',
    region: 'us-west-002',
    bucket: ENV.fetch('B2_BUCKET', nil),
    access_key_id: ENV.fetch('B2_ACCESS_KEY_ID', nil),
    secret_access_key: ENV.fetch('B2_SECRET_ACCESS_KEY', nil)
  )

  # Mirror storage
  digitalocean = Shrine::Storage::S3.new(
    endpoint: 'https://sfo3.digitaloceanspaces.com',
    region: 'sfo3',
    bucket: ENV.fetch('DO_BUCKET', nil),
    access_key_id: ENV.fetch('DO_ACCESS_KEY_ID', nil),
    secret_access_key: ENV.fetch('DO_SECRET_ACCESS_KEY', nil)
  )

  Shrine.storages = {
    store: backblaze,
    cache: cache,
    digitalocean: digitalocean
  }
  Shrine.plugin :mirroring, mirror: { store: :digitalocean }
else
  store = Shrine::Storage::S3.new(**{
    endpoint: ENV.fetch('AWS_ENDPOINT', nil),
    region: 'us-east-1',
    bucket: ENV.fetch('AWS_BUCKET', 'kitsu-media'),
    force_path_style: true
  }.compact)
  cache = Shrine::Storage::S3.new(**{
    endpoint: ENV.fetch('AWS_ENDPOINT', nil),
    region: 'us-east-1',
    bucket: ENV.fetch('AWS_BUCKET', 'kitsu-media'),
    prefix: 'cache',
    force_path_style: true
  }.compact)
  Shrine.storages = {
    store: store,
    cache: cache
  }
end

Shrine::Attacher.promote_block do |attacher|
  attacher.atomic_promote
  ShrineDerivativeWorker.perform_async(attacher)
end
