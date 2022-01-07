puts "Creating users..."

Faker::Config.locale = "ja"

500.times do
  gender = User.genders.keys.sample

  User.create!(
    first_name: gender == "male" ? Faker::Name.male_first_name : Faker::Name.female_first_name,
    last_name: Faker::Name.last_name,
    gender: gender,
    birthdate:  Faker::Date.birthday(min_age: 18, max_age: 65),
    prefecture_id: Prefecture.all.sample.id
  )
end

puts "Finished"
