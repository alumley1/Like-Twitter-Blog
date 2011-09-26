require 'faker'

namespace :db do
  desc "Fill database with fake users"
  task :populate => :environment do
    150.times do
      user = User.create!(:email => Faker::Internet.email, :name => Faker::Name.name, :password => "foobar")
      user.confirm!
     300.times do
         already_have = user.friends.map(&:id) + [user.id]
         users_array = User.where(['id NOT IN (?)', already_have])
         begin
           user.friendships.create!(:friend_id => users_array.to_a.sample.id)
         rescue
          puts "NEXT"
         end
      end
      100.times do
        user.tweets.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end
