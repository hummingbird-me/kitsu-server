require 'rails_helper'

RSpec.shared_examples 'titleable' do
  # Columns which are mandatory for all titleables
  it { is_expected.to have_db_column(:titles).of_type(:hstore) }
  it { is_expected.to have_db_column(:canonical_title).of_type(:string) }
  # Methods used for the magic
  it { is_expected.to respond_to(:canonical_title) }
end
