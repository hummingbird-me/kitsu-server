require 'rails_helper'

RSpec.describe WikiSubmissionLog, type: :model do
  it { is_expected.to belong_to(:user).required }
  it { is_expected.to belong_to(:wiki_submission).required }
end
