FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    synopsis { Faker::Lorem.paragraph(sentence_count: 5) }
    release_year { 2010 }
    duration { Faker::Number.between(from: 80, to: 180) }
    director { Faker::Name.name }
    cast { Faker::Name.name + ", " + Faker::Name.name }
    watch_at_home { false }
    watch_in_cinemas { true }
    manequim_films { false }
    vitrine_session { true }
    association :user
  end
end
