require 'rails_helper'

RSpec.describe Drama, type: :model do
  subject { build(:drama) }
  include_examples 'media'
  include_examples 'episodic'
  include_examples 'age_ratings'
end
