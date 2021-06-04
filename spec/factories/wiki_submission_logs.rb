FactoryBot.define do
  factory :wiki_submission_log do
    association :user
    association :wiki_submission
  end
end
