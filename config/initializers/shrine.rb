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

# This clusterfuck is temporary until we're off AWS
cache = if ENV['B2_BUCKET'].present?
          Shrine::Storage::S3.new(
            endpoint: 'https://s3.us-west-002.backblazeb2.com',
            region: 'us-west-002',
            bucket: ENV['B2_BUCKET'],
            access_key_id: ENV['B2_ACCESS_KEY_ID'],
            secret_access_key: ENV['B2_SECRET_ACCESS_KEY']
          )
        else
          Shrine::Storage::S3.new({
            endpoint: ENV['AWS_ENDPOINT'] || nil,
            region: 'us-east-1',
            bucket: ENV['AWS_BUCKET'] || 'kitsu-media',
            force_path_style: true
          }.compact)
        end

aws = Shrine::Storage::S3.new({
  endpoint: ENV['AWS_ENDPOINT'] || nil,
  region: 'us-east-1',
  bucket: ENV['AWS_BUCKET'] || 'kitsu-media',
  force_path_style: true
}.compact)

Shrine.storages = {
  backblaze: backblaze,
  digitalocean: digitalocean,
  cache: cache,
  store: aws
}.compact

Shrine.plugin :mirroring, mirror: {
  store: Shrine.storages.keys & %i[backblaze digitalocean]
}

Shrine::Attacher.promote_block do |attacher|
  attacher.atomic_promote
  ShrineDerivativeWorker.perform_async(attacher)
end
