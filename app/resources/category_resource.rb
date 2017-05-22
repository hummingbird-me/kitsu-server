require 'unlimited_paginator'

class CategoryResource < BaseResource
  attributes :title, :description, :total_media_count, :slug
  attribute :image, format: :attachment

  has_one :parent
  has_many :anime
  has_many :drama
  has_many :manga

  paginator :unlimited

  filter :parent_id, :slug
end
