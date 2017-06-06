require 'unlimited_paginator'

class MediaAttributeResource < BaseResource
  attribute :title

  has_many :anime
  has_many :drama
  has_many :manga

  paginator :unlimited

  filter :slug
end
