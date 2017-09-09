require 'unlimited_paginator'

class StreamerResource < BaseResource
  attributes :site_name
  attributes :logo, format: :attachment

  has_many :streaming_links

  paginator :unlimited
end
