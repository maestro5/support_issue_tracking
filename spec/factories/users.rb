FactoryGirl.define do
  factory :user do
    name 'Bob Manager'
    email Faker::Internet.email
    password 'password'
  end
end
