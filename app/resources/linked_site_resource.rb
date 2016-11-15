class LinkedSiteResource < BaseResource
  immutable
  attributes :name, :share_to, :share_from, :link_type
end
