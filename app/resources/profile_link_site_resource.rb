require 'unlimited_paginator'

class ProfileLinkSiteResource < BaseResource
  immutable
  paginator UnlimitedPaginator
  attribute :name
end
