# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :set_p3p_header
  ensure_authenticated_to_facebook
  before_filter :setup_facebook_user
  before_filter :set_locale
  before_filter :set_timezone
  #before_filter :set_preload_fql

  private
  def setup_facebook_user
    @current_facebook_user = facebook_session.user if facebook_session
    session[:current_facebook_user_id] ||= (params[:fb_sig_user] || @current_facebook_user.uid) if @current_facebook_user

    if params[:user_id]
      @user = User.find(params[:user_id])
      @me = User.find_by_fb_id(session[:current_facebook_user_id])
    else
      unless session[:user]      
        if @user = User.find_or_initialize_by_fb_id(session[:current_facebook_user_id])
          if @current_facebook_user
            @user.name = @current_facebook_user.name
            @user.image = @current_facebook_user.pic_square
            @user.save!
          end
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
                 elsif @current_facebook_user && AVAILABLE_LOCALES.include?(params[:fb_sig_locale] || @current_facebook_user.locale)
                   session[:locale] = @current_facebook_user.locale
                 end
  end

  def set_timezone
    Time.zone = @user.timezone if @user.timezone
  end

  def set_p3p_header
    response.headers['P3P'] = 'CP=CAO PSA OUR'
  end

  def set_preload_fql
    preload_fql = Hash.new
    preload_fql[:fb_post_sig_preload_user_permission] = {
      :pattern => ".*",
      :query => "SELECT publish_stream FROM permissions WHERE uid={*user*};"
    }
    
    preload_fql[:fb_post_sig_preload_friends] = {
      :pattern => ".*",
      :query => "SELECT uid2 FROM friend WHERE uid1={*user*};"
    }
#
#    preload_fql[:preload_friend_ids_and_names] = {
#      :pattern => ".*",
#      :query => "SELECT uid, name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1={*user*});"
#    }
#
#    preload_fql[:preload_friend_name] = {
#      :pattern => ".*",
#      :query => "SELECT name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1={*user*});"
#    }
#    
#    preload_fql[:preload_male_friend_name] = {
#      :pattern => ".*",
#      :query => "SELECT name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1={*user*}) AND sex='male';"
#    }
#    
#    preload_fql[:preload_female_friend_name] = {
#      :pattern => ".*",
#      :query => "SELECT name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1={*user*}) AND sex='female';"
#    }

    Facebooker::Admin.new(Facebooker::Session.create).set_app_properties({:preload_fql => preload_fql.to_json})
  end
end
