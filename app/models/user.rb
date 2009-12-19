# == Schema Information
# Schema version: 20091209230600
#
# Table name: users
#
#  id          :integer(4)      not null, primary key
#  fb_id       :string(255)
#  target_time :datetime
#  created_at  :datetime
#  updated_at  :datetime
#  timezone    :string(255)     default("Taipei")
#  name        :string(255)
#  image       :string(255)
#

class User < ActiveRecord::Base
  has_many :records
  has_one :status

  validates_presence_of :name, :fb_id

  after_create :create_default_user_setting

  named_scope :unactived, :include => :status, :conditions => ["statuses.state <> ? AND statuses.state <> ? AND statuses.state <> ?", 1, 2, 4]
  named_scope :actived, :include => :status, :conditions => {:statuses => {:state => [1, 2]}}

  named_scope :timezone_in, lambda{|zones| {:conditions => {:timezone => zones}}}
  named_scope :target_less_than, lambda{|time| {:conditions => ["users.target_time < ?", time]}}
  named_scope :order_by_score, :include => :status, :order => "statuses.total_score DESC"
  named_scope :in_limit, lambda{|num| {:limit => num}}
  named_scope :score_higher_than, lambda{|score| {:include => :status, :conditions => ["statuses.total_score > ?",score]}}

#  status = Status.content_columns.inject([]) do |result, column|
#    result << column.name
#  end.push(:to => :status)
#
#  delegate *status
  

  def create_default_user_setting
    self.create_status
  end

  def see_rank_check(zone, time)
    self.timezone == zone && (self.target_time && self.target_time < time)
  end

  def is_rookie?
    (self.target_time.nil? || self.records.count < 2)
  end
end
