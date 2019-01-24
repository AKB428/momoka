#
# ステータステーブルをCSV形式で出力
#
# bundle exe ruby status2csv.rb database_name original_list.txt > /tmp/va_status.csv
#
#

require 'sequel'

@db = Sequel.mysql2(ARGV[0], :host=>'localhost', :user=>'root', :password=>'', :port=>'3306')

status_rows = @db[:twitter_follwer_status].reverse(:follower).select_hash(:screen_name, :follower)

#status_rows.each do |k, v|
#  puts "#{k},#{v}"
#end


File.open(ARGV[1], 'r') do |f|
  while line  = f.gets
    line = line.chomp
    if line != ''

      account = line.split('/')[3]

      puts "#{line},#{status_rows[account]}"
    else
      puts ','
    end
  end
end