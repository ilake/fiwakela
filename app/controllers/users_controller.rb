class UsersController < ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook
  def edit
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # PUT /records/1
  # PUT /records/1.xml
  def update
    set_target_time
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to records_path }
        format.js
      else
        format.html { render :action => "edit" }
      end
    end
  end

  private
  def set_target_time
    Time.zone = params[:user][:timezone]
    now = Time.zone.now
    params[:user][:target_time] = Time.zone.local(1982, 1, 8, params[:date][:hour], params[:date][:minute], 0)
  end
end
