class RanksController < ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook
  layout 'records'
  def index
    @timezone = params[:timezone] ? params[:timezone] : @user.timezone
    @hour     = params[:date] ? params[:date][:hour] : 8

    Time.zone = @timezone 
    @target_time = Time.zone.local(1982, 1, 8, @hour, 0, 0)
    @users = User.timezone_in(@timezone).target_less_than(@target_time).order_by_score.in_limit(20).find(:all, :select => "users.fb_id, users.target_time ,users.timezone, statuses.total_score")

    @rank = User.timezone_in(@timezone).target_less_than(@target_time).score_higher_than(@user.status.total_score).count(:all, :select => "users.timezone, users.target_time, statuses.total_score") + 1 if @watch_rank = @user.see_rank_check(@timezone, @target_time)
  end
end
