require 'unlimited_paginator'

class CategoryResource < BaseResource
  attributes :title, :description, :total_media_count,
    :slug, :nsfw, :child_count
  attribute :image, format: :attachment

  has_one :parent
  has_many :anime
  has_many :drama
  has_many :manga

  paginator :unlimited

  filters :parent_id, :slug, :nsfw
end
