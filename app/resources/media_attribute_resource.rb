require 'unlimited_paginator'

class MediaAttributeResource < BaseResource
  attributes :title, :high_title, :neutral_title, :low_title

  has_many :anime
  has_many :drama
  has_many :manga

  paginator :unlimited

  filter :slug
end
