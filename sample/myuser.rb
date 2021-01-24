require 'pp'
require "./twitter.rb"

#https://rdoc.info/gems/twitter/Twitter/REST/Client

#pp @tw.users(ARGV[0])

pp @tw.friend_ids(ARGV[0])

