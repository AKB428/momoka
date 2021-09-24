#Sana Batch For Voice Actor
#http://www.rubydoc.info/gems/twitter/Twitter/User#location-instance_method
require 'sequel'
require 'pp'
require "./twitter.rb"

<<AAA
#connections ⇒ Array readonly
#description ⇒ String readonly
#favourites_count ⇒ Integer (also: #favorites_count) readonly
#followers_count ⇒ Integer readonly
#friends_count ⇒ Integer readonly
#lang ⇒ String readonly
#listed_count ⇒ Integer readonly
#location ⇒ String readonly
#name ⇒ String readonly
#profile_background_color ⇒ String readonly
#profile_link_color ⇒ String readonly
#profile_sidebar_border_color ⇒ String readonly
#profile_sidebar_fill_color ⇒ String readonly
#profile_text_color ⇒ String readonly
#statuses_count ⇒ Integer (also: #tweets_count) readonly
#time_zone ⇒ String readonly
#utc_offset ⇒ Integer readonly

#screen_name

MAX_USERS_PER_REQUEST = 100

https://dev.twitter.com/rest/public/rate-limiting
AAA

<<BBB
@tw.users(account_list).each do |user|
  puts user.name
  puts user.screen_name
  puts user.followers_count
end
BBB

@today = DateTime.now

@db = Sequel.mysql2(ARGV[0], :host=>ENV['MOMOKA_DB_HOST'], :user=>ENV['MOMOKA_DB_USER'], :password=>ENV['MOMOKA_DB_PASSWORD'], :port=>'3306')

@status_rows = []
@history_rows = []
#アカウントをキーとしたハッシュを作る 必要な値はID
@account_key_hash = {}

@twitter_result_account = []

def connect_twitter(account_list)
  @tw.users(account_list).each do |user|
    @status_rows << [
        user.followers_count,
        @today,
        @today,
        #user.name,
        #user.description.to_s,
        user.favorites_count,
        user.friends_count,
        user.listed_count,
        user.screen_name,
        user.profile_image_url.to_s,
        user.statuses_count
    ]
    #if @account_key_hash[user.screen_name] != nil

    @history_rows << [
        user.screen_name,
        user.followers_count,
        @today,
        @today,
        @today,
      #  user.name,
       # user.description.to_s,
        user.favorites_count,
        user.friends_count,
        user.listed_count,
        user.screen_name,
        user.profile_image_url.to_s,
        user.statuses_count
    ]
    #if @account_key_hash[user.screen_name] != nil


      @twitter_result_account << user.screen_name
  end
end

def save_db()
  #結果をstatusに格納(truncate -> insert)
  @db[:twitter_follwer_status].import([
                                                      :follower,
                                                      :created_at,
                                                      :updated_at,
                                                    #  :name,
                                                     # :description,
                                                      :favourites_count,
                                                      :friends_count,
                                                      :listed_count,
                                                      :screen_name,
                                                      :profile_image_url,
                                                      :statuses_count
                                                  ], @status_rows)

  #結果をhistoryに格納(insertのみ)
  @db[:twitter_follwer_status_histories].import([
                                                                :key_name,
                                                                :follower,
                                                                :get_date,
                                                                :created_at,
                                                                :updated_at,
                                                      #          :name,
                                                       #         :description,
                                                                :favourites_count,
                                                                :friends_count,
                                                                :listed_count,
                                                                :screen_name,
                                                                :profile_image_url,
                                                                :statuses_count
                                                            ], @history_rows)
end

ONE_REQUEST_LIMIT_NUM = 60
ONE_REQUEST_SLEEP_SEC = 60

account_list = []

File.open(ARGV[1], 'r') do |f|
  while line  = f.gets
    line = line.chomp
    account_list << line
  end
end

@db[:twitter_follwer_status].truncate

p account_list

account_list.each_slice(ONE_REQUEST_LIMIT_NUM).to_a.each do |account_slist|
  puts account_slist.size
  #配列を区切ってTwitterにリクエスト
  connect_twitter(account_slist)

  save_db()
  puts 'sleep'
  sleep ONE_REQUEST_SLEEP_SEC

  @status_rows = []
  @history_rows = []
end



p account_list - @twitter_result_account

#処理を終了する ループはcrontabでやる
#６時間に１度ぐらいで
