User.create!( name:   "Fabian",
              email:  "stahlschiff@web.de",
              password:               "password",
              password_confirmation:  "password",
              admin:  true,
              activated: true,
              activated_at: Time.zone.now )

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = 'password'
  User.create!( name:   name,
                email:  email,
                password:               password,
                password_confirmation:  password,
                activated: true,
                activated_at: Time.zone.now )
end

# microposts
users = User.order(:created_at).take(7)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content)}
end

# following relationships
users = User.all
user = User.first
following = users[2..10000]
followers = users[3..9999]
following.each { |followed| user.follow followed }
followers.each { |follower| follower.follow user }
