desc "This task is called by the Heroku scheduler add-on"

task :send_weekly_summary => :environment do
  if Date.today.wday.zero?
    User.all.each do |user|
      date_of_newest_feed_entry = nil

      n = 0
      while date_of_newest_feed_entry.nil?
        post = user.feed.offset(n).first
        if post.nil?
          break
        end
        if post.user_id != user.id
          date_of_newest_feed_entry = post.created_at
        end
        n = n+1
      end
      unless date_of_newest_feed_entry.nil?
        unless user.last_login.nil?
          if date_of_newest_feed_entry > user.last_login
            user.send_weekly_summary
          end
        end
      end
    end
  end
end
