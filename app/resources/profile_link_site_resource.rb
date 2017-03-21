require 'unlimited_paginator'

class ProfileLinkSiteResource < BaseResource
  immutable
  paginator :unlimited
  attribute :name
end
