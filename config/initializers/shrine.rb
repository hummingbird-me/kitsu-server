require 'shrine/storage/s3'
require 'paperclip_shrine_synchronization'

s3_options = {
  bucket: 'kitsu-media',
  region: 'us-east-1'
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(**s3_options),
}
