class RanksController < ApplicationController
  layout 'records'
  def index
    @timezone = params[:timezone] ? params[:timezone] : @user.timezone
    @hour     = params[:date] ? params[:date][:hour] : 8

    Time.zone = @timezone 
    @target_time = Time.zone.local(1982, 1, 8, @hour, 0, 0)
    @users = User.find(:all, :include => :status,
                       :select => "users.fb_id, users.target_time ,users.timezone, statuses.total_score",
                       :conditions => ["users.timezone = ? AND users.target_time < ? ", @timezone, @target_time],
                       :order => "statuses.total_score DESC", :limit => 20)

    @rank = User.count(:all, :include => :status,
                       :select => "users.timezone, users.target_time, statuses.total_score",
                       :conditions => ["users.timezone = ? AND total_score > ? AND users.target_time < ?", @timezone, @user.status.total_score, @target_time]) + 1 if @user.see_rank_check(@timezone, @target_time) 
  end
end
