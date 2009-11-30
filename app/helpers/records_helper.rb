module RecordsHelper
  def owner_area(&block)
    if @user.fb_id == @current_facebook_user.id.to_s
      concat capture(&block)
    end
  end
end
