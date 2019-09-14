require 'pp'
require "./twitter.rb"

#https://obel.hatenablog.jp/entry/20170629/1498707124
#https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/get-statuses-retweeters-ids.html
#https://www.rubydoc.info/gems/twitter/Twitter/REST/Tweets#retweets-instance_method
#
query = ARGV[0]

cursor = 1
result = {}

# cursorオプションはRuby gem経由で設定されない、そもそもAPI側でも無効っぽい
rt_tweets = @tw.retweets(query, {"count": 100, "cursor": cursor})

rt_tweets.each do |rt_tweet|
  #puts "#{rt_tweet.id},#{rt_tweet.user.screen_name},https://twitter.com/#{rt_tweet.user.screen_name}/status/#{rt_tweet.id}"
    result[rt_tweet.id] = rt_tweet.user.screen_name
end

result.sort.each do |r|

  id = r[0]
  twitter_name = r[1]

  puts "#{id},#{twitter_name},https://twitter.com/#{twitter_name}/status/#{id}"
end