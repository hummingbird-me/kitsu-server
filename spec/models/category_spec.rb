# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  canonical_title    :string
#  description        :string
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  titles             :hstore
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  anidb_id           :integer          indexed
#
# Indexes
#
#  index_categories_on_anidb_id  (anidb_id)
#

require 'rails_helper'

RSpec.describe Category, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
