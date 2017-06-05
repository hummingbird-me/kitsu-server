require 'unlimited_paginator'

class MediaAttributeResource < BaseResource
  attributes :title, :high_vote_count, :neutral_vote_count,
    :low_vote_count

  has_many :anime
  has_many :drama
  has_many :manga

  paginator :unlimited

  filter :slug
end
