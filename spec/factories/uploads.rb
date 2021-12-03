FactoryBot.define do
  factory :upload do
    user
    content { Fixture.new('image.png').to_file }
  end
end
