FactoryGirl.define do
  factory :song do
    title { Faker::Hipster.sentence(4) }
    artist { Faker::RockBand.name }
    length { Faker::Number.number(4) }
    playlist_id nil
  end
end