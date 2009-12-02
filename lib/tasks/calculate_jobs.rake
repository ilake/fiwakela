namespace :cal do 
  desc 'step1: calculate performance'
  task :performance => :environment do 
    #state 4 是太久沒來的, 每天在reset_all_state rake 裡做更新
    #只是缺席或請假的才算, 今天有來(state 1 or 2)的也不算
    User.unactived.each do |user|
      status  = user.status

      #下面算績效的統一做
      #平均雖然也是績效之一  可是沒來的不知道要怎樣算, 所以搬回record 存 wake_up的時候算
      user.status.success_rate = user.records.cal_success_rate
      user.status.continuous_num = user.records.cal_continuous_num
      user.status.score = user.records.cal_score
      user.status.save!
    end
  end

  desc 'step2: reset_all_state'
  task :reset_state => :performance do
    #最近一星期 fight 設成false, state 設成4
    #今天有來(state = 1 or 2)
    #反正只是缺席或請假的才算
    User.unactived.each do |u|
      if r = u.records.order_by('time').first
        unless r.time > Time.now.ago(1.week)
          u.status.update_attribute(:state, 4)
        end
      else
        #因為有可能很多一次都沒紀錄的, 只要每天檢查有沒紀錄的state 就先設成4 
        #只要他有做紀錄就會state 變成1 or 2, fight也會變成true
        u.status.update_attribute(:state, 4)
      end
    end

    Status.update_all("state = 0", "state <> 4")
  end

  desc 'daily_jobs'
  task :daily_jobs => :reset_state do
  end
      
  desc 'use mail to test cron'
  task :test_cron => :environment do
    EbMail.deliver_weekly_report(User.find(2)) 
  end

  desc 'each hours reset time zone'
  task :reset_by_timezone => :environment do
    h = Time.now.utc.hour 
    #h = -11 跟 13 同時reset
    if h < 12
      h = h*-1
    elsif h > 13
      h = 25 -h
    end
    #h is the timezone need to reset
    zones = ActiveSupport::TimeZone::ZONES.map{|t| [t.name, t.utc_offset.to_utc_offset_s] if t.utc_offset/3600.0 < h+1 && t.utc_offset/3600.0 >= h}.compact
    Time.zone = zones[0][0]
    RAILS_DEFAULT_LOGGER.info("TIMEZONE~~#{Time.now.utc}~~~~( #{h} )~~~~( #{Time.zone.utc_offset.to_utc_offset_s} )~~~#{Time.zone.now}~~~~#{zones.inspect}~~~")

    if h == -11
      h = 13
      zones = ActiveSupport::TimeZone::ZONES.map{|t| [t.name, t.utc_offset.to_utc_offset_s] if t.utc_offset/3600.0 < h+1 && t.utc_offset/3600.0 >= h}.compact
      Time.zone = zones[0][0]
      RAILS_DEFAULT_LOGGER.info("TIMEZONE~~#{Time.now.utc}~~~~( #{h} )~~~~( #{Time.zone.utc_offset.to_utc_offset_s} )~~~#{Time.zone.now}~~~~#{zones.inspect}~~~")

    end
  end

end
