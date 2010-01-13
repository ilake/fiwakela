# == Schema Information
# Schema version: 20100112150513
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
#  badges         :integer(4)
#

#state 
#0 is 缺席
#1 is 成功 
#2 is 失敗
#3 is 請假
#4 is 太久沒來的
#num 日誌的總數

class Status < ActiveRecord::Base
  include FlagShihTzu

  belongs_to :user

  BADGES_COLUMN = [1 => :num_7, 2 => :num_30, 3 => :num_100, 4 => :num_365, 
                   11 => :con_7, 12 => :con_30, 13 => :con_100, 14 => :con_365]
  BADGES_COLUMN.push(:column => 'badges')
  
  has_flags *BADGES_COLUMN
            

  def cal_total_score(friend_ids)
    total = Status.sum("score", :joins => :user, :conditions => {:users => {:fb_id => friend_ids}})
    self.total_score = total + self.score
    self.save!
  end

  def update_badges(amount, cont_num)
    if cont_num == 2
      self.con_2 = true
    elsif cont_num == 4
      self.con_4 = true
    end

    if amount == 3
      self.num_3 = true
    elsif amount == 5
      self.num_5 = true
    end
  end
end
