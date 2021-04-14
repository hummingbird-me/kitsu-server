require 'rails_helper'

RSpec.describe WikiSubmissionLog, type: :model do
  it { should belong_to(:user).required }
  it { should belong_to(:wiki_submission).required }
end
