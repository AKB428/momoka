require 'pp'
require "./twitter.rb"

query = ARGV[0]
since_id = nil
result_tweets = @tw.search(query, count: 100, result_type: "recent",  exclude: "retweets", since_id: since_id)

# https://qiita.com/riocampos/items/6999a52460dd7df941ea
#

result_tweets.each_with_index do |tw, i|
  puts "#{i}: @#{tw.user.screen_name}: #{tw.full_text}"
end