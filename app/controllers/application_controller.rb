# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  ensure_authenticated_to_facebook
  before_filter :setup_facebook_user
  before_filter :set_locale
  before_filter :set_timezone

  
  private
  def setup_facebook_user
    @current_facebook_user = facebook_session.user if facebook_session
    session[:current_facebook_user_id] = @current_facebook_user.uid if @current_facebook_user
    if params[:user_id]
      @user = User.find(params[:user_id])
      @me = User.find_by_fb_id(@current_facebook_user.id)
    else
      unless session[:user]      
        #if @user = User.find_or_initialize_by_fb_id(@current_facebook_user.uid.to_s)
        if @user = User.find_or_initialize_by_fb_id(session[:current_facebook_user_id])
          @user.name = @current_facebook_user.name if @current_facebook_user
          @user.image = @current_facebook_user.pic_square if @current_facebook_user
          @user.save!
          @me = @user
          session[:user] = @user.id
        end
      else              
        @user = User.find(session[:user])
        @me = @user
      end
    end
  end
  
  def set_locale
    I18n.locale = if session[:locale]
                   session[:locale]
                 elsif AVAILABLE_LOCALES.include?(@current_facebook_user.locale)
                   session[:locale] = @current_facebook_user.locale
                 end
  end

  def set_timezone
    Time.zone = @user.timezone if @user.timezone
  end
end
