MAX_HAMMING = 5
MAX_LCS = 0.5

namespace :tweets do
  desc 'Auto publish tweets for specific politicians'
  task :auto_publish => :environment do
    puts "Start ... "
    pcount = Politician.with_auto_publish.active.count 
    tweets_count=0

    Politician.with_auto_publish.active.each do |politician|
      tweets_count +=politician.deleted_tweets.waiting_review.update_all("reviewed = 1, approved = 1, reviewed_at = '#{Time.now}', reviewed_by_id = 0", 
                              "(modified - created) > #{Admin::SysSetting.auto_publish_delay_seconds}")
      print '#'
    end
    puts "published #{tweets_count} tweets of #{pcount} politicians"
    puts "Done. "
  end
  desc 'Auto reject tweets if the tweep has posted a similar tweet'
  task :auto_reject => :environment do
    puts "Start ... "
    count = 0
    deleted_tweets = DeletedTweet.where(:politician_id => Politician.active.all)
    deleted_tweets.where("reviewed_at IS  NULL").where(:reviewed=>false).each do |deleted_tweet|
      tweets = Tweet.where(:politician_id => deleted_tweet.politician_id , :deleted => 0,
      :created => deleted_tweet.created..DateTime.now).order("created ASC").limit(1)
      tweets.each do |tweet|
        deleted_tweet.reviewed_at =  Time.now
        if is_similar(tweet.content.upcase,deleted_tweet.content.upcase) 
           deleted_tweet.reviewed = true
           deleted_tweet.approved = false
           deleted_tweet.reviewed_by = nil
           count+=1
           puts "#{count} tweets auto rejected. "
        end
        deleted_tweet.save
      end
    end
    puts "Done. "
  end
  
  desc 'Update the invalid short_url for all tweets'
  task :update_invalid_short_url => :environment do
    puts "Start ... "
    DeletedTweet.update_all("short_url = null", "short_url = 'http://goo.gl/jA3i'")
    puts "Done. "
  end

  def hamming_distance(str1, str2)
    str1.split(//).zip(str2.split(//)).inject(0) { |h, e| e[0]==e[1] ? h+0 : h+1 }
  end
  def lcs(s1, s2)
    if (s1 == "" || s2 == "")
      return ""
    end
    m = Array.new(s1.length){ [0] * s2.length }
    longest_length, longest_end_pos = 0,0
    (0 .. s1.length - 1).each do |x|
      (0 .. s2.length - 1).each do |y|
        if s1[x] == s2[y]
          m[x][y] = 1
          if (x > 0 && y > 0)
            m[x][y] += m[x-1][y-1]
          end
          if m[x][y] > longest_length
            longest_length = m[x][y]
            longest_end_pos = x
          end
        end
      end
    end
    return s1[longest_end_pos - longest_length + 1 .. longest_end_pos]
  end

  def is_similar(str1, str2)
    
    max_size = [str1.size,str2.size].max
    min_size = [str1.size,str2.size].min
    hamming_distance = hamming_distance(str1,str2) + max_size -  min_size
    max_hamming = MAX_HAMMING
    lcs_size = lcs(str1, str2).size
    max_lcs_ratio = MAX_LCS
    if (hamming_distance <= max_hamming || lcs_size.to_f/max_size.to_f >= max_lcs_ratio )
      return true
    else
      return false
    end
  end

end
