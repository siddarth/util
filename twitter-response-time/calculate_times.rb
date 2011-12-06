require 'twitter'
require 'time'

raise "Usage: ruby calculate_times.rb TWITTER_HANDLE NUM_PAGES" unless ARGV.length == 2

num_pages = ARGV[1].to_i
user = ARGV[0]

total_time = 0.0
num_tweets = 0

(1..num_pages).each { |page_num|
  timeline = Twitter.user_timeline(user, { "page" => page_num })
  timeline.each { |tweet|
    next if tweet.in_reply_to_status_id.nil?
    #puts tweet.text
    response_time = Time.parse(tweet.created_at)
    in_reply_to = Twitter.status(tweet.in_reply_to_status_id)
    original_time = Time.parse(in_reply_to.created_at)
    num_tweets += 1
    total_time += (response_time - original_time)
    if (num_tweets % 100 == 0)
      str = "[info] Average response time = %f " % (total_time / num_tweets )
      str += "after %d tweets\n" % num_tweets
      print str
    end
  }
}
