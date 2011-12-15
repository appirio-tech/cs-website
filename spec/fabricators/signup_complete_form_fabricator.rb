Fabricator(:signup_complete_form) do
  email { Faker::Internet.email }
  name { Faker::Name.name }
  username { Faker::Name.name.downcase }
  uid { sequence(:uid) }
  provider { Faker::Name.name }
end
