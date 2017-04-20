FactoryGirl.define do
  factory :library_event do
    association :library_entry, strategy: :build

    event :updated
    status :planned
  end
end
