class MediaProduction < ApplicationRecord
  enum role: %i[producer licensor studio serialization]

  belongs_to :media, polymorphic: true, inverse_of: :productions
  belongs_to :company, class_name: 'Producer'

  def rails_admin_label
    company.name
  end
end
