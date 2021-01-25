require 'pp'
require "./twitter.rb"
require "csv"
require "fileutils"

#https://rdoc.info/gems/twitter/Twitter/REST/Client

ONE_REQUEST_LIMIT_NUM = 60
ONE_REQUEST_SLEEP_SEC = 60

CSV_FOLDER = 'private'

target_twitter_account = ARGV[0]

# CSVを出力するフォルダを作成
FileUtils.mkdir_p(CSV_FOLDER) unless File.exists?(CSV_FOLDER)

csv_file_name = "./#{CSV_FOLDER}/#{target_twitter_account}_follower_list.csv"

# 第一引数に対象のアカウントを指定、基本的用途としては自分のscreen_nameを指定することを想定
follower_list =  @tw.friend_ids(target_twitter_account).attrs[:ids]

# フォローが新しい順に入っているので古いものを先にする
follower_list.reverse!

puts follower_list.size

# 15分 900 = 1時間 3600
cost_hour = follower_list.size / 3600.to_f
puts "予想時間 #{cost_hour} 時間"

cost_hour_min = follower_list.size / ONE_REQUEST_LIMIT_NUM
puts "予想分数 #{cost_hour_min} 分"

if File.exist?(csv_file_name)
  File.delete csv_file_name
end

@status_total_rows = []

CSV.open(csv_file_name,'a') do |csv|
  csv << %w(id screen_name name url description location profile_image_url_https created_at followers_count favorites_count friends_count listed_count statuses_count)
end

def connect_twitter(account_list)
    status_rows = []
    # https://rdoc.info/gems/twitter/Twitter/REST/Users#users-instance_method
    @tw.users(account_list).each do |user|
      status_rows << [
          user.id,
          user.screen_name,
          user.name,
          "https://twitter.com/#{user.screen_name}",
          user.description,
          user.location,
          user.profile_image_url_https, #48x48
          user.created_at,
          user.followers_count,
          user.favorites_count,
          user.friends_count,
          user.listed_count,
          #user.profile_image_url.to_s,
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