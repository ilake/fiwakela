class IndexController < ApplicationController
  layout 'records'
  def index
  end

  def friend
    u = @facebook_session.user  
    @e_ids = "" 
    u.friends_with_this_app.map { |e| @e_ids += e.uid.to_s+"," }
    logger.info @e_ids
  end
end
