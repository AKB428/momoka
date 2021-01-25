require 'pp'
require "./twitter.rb"

target_twitter_account = ARGV[0]

user = nil

@tw.users([target_twitter_account]).each do |u|
  user = u
end

#puts user.to_hash
pp user.to_hash