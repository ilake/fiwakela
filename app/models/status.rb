# == Schema Information
# Schema version: 20091129152625
#
# Table name: statuses
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  state          :integer         default(0)
#  continuous_num :integer         default(0)
#  num            :integer         default(0)
#  score          :integer         default(0)
#  average        :datetime
#  success_rate   :float           default(0.0)
#  last_record_at :datetime
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
end
