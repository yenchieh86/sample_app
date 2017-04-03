User.create!(name:  "Yen Chen", 
             email: "yenchieh86@hotmail.com", 
             password: "111111", 
             password_confirmation: "111111", 
             admin: true, 
             activated: true, 
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name, 
               email: email, 
               password: password, 
               password_confirmation: password, 
               activated: true, 
               activated_at: Time.zone.now)
end