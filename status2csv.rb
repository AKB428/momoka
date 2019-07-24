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

      if status_rows.has_key?(account)
        puts "#{line},#{status_rows[account]},"
      else
        #大文字小文字対策
        status_rows.keys.each do |db_account_name|
          #puts "#{db_account_name} #{account}"
          if db_account_name.casecmp(account) == 0
            puts "#{line},#{status_rows[db_account_name]},#{db_account_name}"
            break
          end
        end

      end
    else
      puts ','
    end
  end
end