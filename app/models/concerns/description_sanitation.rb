module DescriptionSanitation
  extend ActiveSupport::Concern

  included do
    before_save :sanitize_description
  end

  def sanitize_description
    description['en'] = Sanitize.fragment(description['en'], Sanitize::Config::RESTRICTED)
  end
end
