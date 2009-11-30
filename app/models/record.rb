# == Schema Information
# Schema version: 20091117232026
#
# Table name: records
#
#  id          :integer         not null, primary key
#  time        :datetime
#  target_time :datetime
#  content     :text
#  user_id     :integer
#  success     :boolean         default(TRUE)
#  pri         :boolean
#  status      :boolean         default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

# status false 補上,  true 即時
# pri    true  private,  false  public
class Record < ActiveRecord::Base
  include Common
  belongs_to :user

  before_create :set_target_time
  before_create :set_success
  before_update :modified_record_state, :if => Proc.new{|record| record.time_changed?}
  before_update :set_success, :if => Proc.new {|record| record.time_changed? }

  named_scope :success, :conditions => {:success => true}
  named_scope :fail, :conditions => {:success => false}
  named_scope :order_by, lambda{|cond|
    case cond
    when 'time'
      {:order => "#{cond} DESC"}
    else
      {:order => cond}
    end
  }
  named_scope :time_in, lambda{|start, endtime|{:conditions => ["time > ? AND time < ?", Time.zone.parse(start), Time.zone.parse(endtime).end_of_day]}}

  def set_target_time
    self.target_time ||= self.create_target_time(self.user)
  end

  #把user 設定的 X:20分 弄成 X:20分59秒
  def set_success
    unless self.target_time.blank?
      self.success = self.time > self.target_time.since(59.seconds) ? false : true
    else
      self.success = true
    end
    true
  end

  def modified_record_state
    self.status = false
    true
  end

  def create_target_time(user)
    if t_time = user.target_time
      Time.zone.local(time.year.to_i, time.month.to_i, time.day.to_i, t_time.hour, t_time.min, 0)
    end
  end

  def self.cal_today_state
    today_rec = self.find(:first, :conditions => ["records.time > '#{Time.zone.now.at_beginning_of_day.to_s(:db)}' AND time < '#{Time.zone.now.tomorrow.midnight.to_s(:db)}'"], :order => 'time DESC')
    state = today_rec ? (today_rec.success ? 1 : 2) : 0
    state
  end

  def self.cal_average(total=true)
    if total
      times = self.find(:all, :limit => 21, :order => 'time DESC').map(&:time)
    else
      times = self.find(:all, :conditions => ["time > ?", Time.zone.now.beginning_of_week]).map(&:time)
    end

    if times.blank?
      #average = Time.mktime( 1982, 1, 8, 0, 0, 0)
      average = Time.zone.local( 1982, 1, 8, 0, 0, 0)
    else
      hours = 0
      minutes= 0

      times.each do |t|
        hours = hours + t.hour
        minutes = minutes + t.min
      end
      total_sec = hours.hour + minutes.minute
      counts = times.size

      #一天起床時間有多少秒
      day_sec = total_sec/counts

      hour = day_sec/3600
      min = (day_sec-hour.hour)/60

      average = Time.zone.local( 1982, 1, 8, hour, min, 0)
      #average = Time.mktime( 1982, 1, 8, hour, min, 0)
    end
  end

  def self.cal_success_rate
    records_success = self.success.count
    if self.first
      all_days = Common.cal_days_interval(self.order_by('time').last.time, Time.zone.now)
      rate = 100*(records_success / all_days.to_f)
      rate > 100 ? 100 : rate
    else
      0
    end
  end

  def self.cal_continuous_num
    last_success = self.success.order_by('time').first
    #最後一次 沒來或最後一次失敗來當最後失敗的時間
    #今天到第一筆紀錄的日子不等於紀錄數  就表示中間有缺
    #兩筆紀錄時間超過兩天就表示有紀錄沒寫
    last_fail = self.fail.order_by('time').first

    all_days = last_success ? Common.cal_days_interval(last_success.time, Time.zone.now) : 0
    #沒來的就算晚起
    if all_days > 1
      num = -1*(all_days-1)
    elsif last_fail.nil?
      num = self.count
    elsif last_success.nil?
      num = self.count*-1
    elsif last_fail.time > last_success.time
      num = self.record_continuous_num(last_success, last_fail)*-1
    else
      num = self.record_continuous_num(last_fail, last_success)
    end

    num = num < 0 ? 0 : num
    num
  end

  def self.record_continuous_num(start_time, end_time)
    self.count(:conditions => ["time > ? and time < ?", start_time.time, end_time.time])+1
  end

  #只算最近21筆紀錄, 來算分數
  #最近21天的成功次數有多少
  def self.cal_score
    success_count = self.success.count(:all, :select => "count(records.id) AS count_all", :order => "records.id DESC", :conditions => "records.time > '#{Time.zone.now.ago(21.days).at_beginning_of_day.to_s(:db)}'")
    total_score = success_count*5
    total_score = 100 if total_score > 100
    total_score
  end
  

end
