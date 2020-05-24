FactoryBot.define do
  factory :message do
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    subject { Faker::Lorem.sentence}
    text { Faker::Lorem.sentences}
  end
end