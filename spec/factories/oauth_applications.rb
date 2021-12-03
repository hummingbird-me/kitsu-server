FactoryBot.define do
  factory :oauth_application, class: ::Doorkeeper::Application do
    name { Faker::Internet.user_name }
    redirect_uri { Faker::Internet.url('example.com').sub('http', 'https') }
    association :owner, factory: :user, strategy: :build
  end
end
