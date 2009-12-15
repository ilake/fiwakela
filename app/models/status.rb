# == Schema Information
# Schema version: 20091209230600
#
# Table name: statuses
#
#  id             :integer(4)      not null, primary key
#  user_id        :integer(4)
#  state          :integer(4)      default(0)
#  continuous_num :integer(4)      default(0)
#  num            :integer(4)      default(0)
#  score          :integer(4)      default(0)
#  average        :datetime
#  success_rate   :float           default(0.0)
#  last_record_at :datetime
#  total_score    :integer(4)      default(0)
#

#state 
#0 is 缺席
#1 is 成功 
#2 is 失敗
#3 is 請假
#4 is 太久沒來的
#num 日誌的總數

class Status < ActiveRecord::Base
  belongs_to :user

  def cal_total_score(friend_ids)
    total = Status.sum("score", :joins => :user, :conditions => {:users => {:fb_id => friend_ids}})
    self.total_score = total + self.score
    self.save!
  end
end
