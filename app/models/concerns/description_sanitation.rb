module DescriptionSanitation
  extend ActiveSupport::Concern

  included do
    before_save :sanitize_description
  end

  def sanitize_description
    description.transform_values! { |desc| Sanitize.fragment(desc, Sanitize::Config::RESTRICTED) }
  end
end
