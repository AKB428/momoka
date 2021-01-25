require 'pp'
require "./twitter.rb"
require "csv"

#https://rdoc.info/gems/twitter/Twitter/REST/Client

# 第一引数に対象のアカウントを指定、基本的用途としては自分のscreen_nameを指定することを想定
follower_list =  @tw.friend_ids(ARGV[0]).attrs[:ids]

puts follower_list.size

# 15分 900 = 1時間 3600
cost_hour = follower_list.size / 3600
puts "予想時間 #{cost_hour} 時間"

ONE_REQUEST_LIMIT_NUM = 60
ONE_REQUEST_SLEEP_SEC = 60

csv_file_name = './private/follower_list.csv'

if File.exist?(csv_file_name)
  File.delete csv_file_name
end

@status_total_rows = []

def connect_twitter(account_list)
    status_rows = []
    # https://rdoc.info/gems/twitter/Twitter/REST/Users#users-instance_method
    @tw.users(account_list).each do |user|
      status_rows << [
          user.screen_name,
          user.name,
          "https://twitter.com/#{user.screen_name}",
          user.description,
          user.profile_image_url_https,
          user.followers_count,
          user.favorites_count,
          user.friends_count,
          user.listed_count,
          user.profile_image_url.to_s,
          user.statuses_count
      ]
    end
    @status_total_rows << status_rows
    status_rows
  end

follower_list.each_slice(ONE_REQUEST_LIMIT_NUM).to_a.each do |account_slist|
  puts account_slist.size
  #配列を区切ってTwitterにリクエスト

  result_account = []

  while result_account.size == 0
    begin
      result_account = connect_twitter(account_slist)
    rescue => e
      p  e
      sleep ONE_REQUEST_SLEEP_SEC
    end
  end

  puts "result:" + result_account.size.to_s

  CSV.open(csv_file_name,'a') do |fl|
    result_account.each do |ra|
      fl << ra
    end
  end

  sleep ONE_REQUEST_SLEEP_SEC

end