FactoryGirl.define do
  factory :ticket do
    reference_number 'ABC-4F-ABC-8D-ABC'
    ticket_status nil
    name Faker::Name.name
    email Faker::Internet.email
    subject Faker::Lorem.sentence
    question Faker::Lorem.paragraph
  end
end
