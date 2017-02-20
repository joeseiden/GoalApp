FactoryGirl.define do
  factory :user do
    name { Faker::StarWars.character }
    password 'stardust'
  end
end
