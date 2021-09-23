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

backblaze = ENV['B2_BUCKET'].presence && Shrine::Storage::S3.new(
  endpoint: 'https://s3.us-west-002.backblazeb2.com',
  region: 'us-west-002',
  bucket: ENV['B2_BUCKET'],
  access_key_id: ENV['B2_ACCESS_KEY_ID'],
  secret_access_key: ENV['B2_SECRET_ACCESS_KEY']
)

digitalocean = ENV['DO_BUCKET'].presence && Shrine::Storage::S3.new(
  endpoint: 'https://sfo3.digitaloceanspaces.com',
  region: 'sfo3',
  bucket: ENV['DO_BUCKET'],
  access_key_id: ENV['DO_ACCESS_KEY_ID'],
  secret_access_key: ENV['DO_SECRET_ACCESS_KEY']
)

cache = Shrine::Storage::S3.new(
  endpoint: 'https://s3.us-west-002.backblazeb2.com',
  region: 'us-west-002',
  bucket: ENV['B2_UPLOAD_BUCKET'],
  access_key_id: ENV['B2_ACCESS_KEY_ID'],
  secret_access_key: ENV['B2_SECRET_ACCESS_KEY']
)

Shrine.storages = {
  digitalocean: digitalocean,
  cache: cache,
  store: backblaze
}.compact

Shrine.plugin :mirroring, mirror: { store: :digitalocean }

Shrine::Attacher.promote_block do |attacher|
  attacher.atomic_promote
  ShrineDerivativeWorker.perform_async(attacher)
end
