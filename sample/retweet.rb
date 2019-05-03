require 'pp'
require "./twitter.rb"

#https://obel.hatenablog.jp/entry/20170629/1498707124
#
query = ARGV[0]

rt_tweets = @tw.retweets(query, {"count": 100})
rt_tweets.each do |rt_tweet|
  puts "screen_name: #{rt_tweet.id}, screen_name: #{rt_tweet.user.screen_name}"
end