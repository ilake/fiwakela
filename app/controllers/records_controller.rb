class RecordsController < ApplicationController
  require 'sanitize'
  include Common
  ensure_application_is_installed_by_facebook_user :only => :auth
  skip_before_filter :ensure_authenticated_to_facebook, :except => [:index, :auth]

  before_filter :find_record, :only => [:show, :edit, :update, :destroy]

  def auth
    redirect_to :action => 'index', :status => 301
  end
  # GET /records
  # GET /records.xml
  def index
    @is_rookie = @me.is_rookie? if @user == @me
    get_date_range
    @records = @user.records.time_in(@startDate, @endDate).order_by('time').all
    @record = Record.new
    @times = Common.time_to_string(@records, 'time')
    @target_times = Common.time_to_string(@records, 'target_time')

    unless session[:friend_ids]
      friends = @current_facebook_user.friends_with_this_app
      friend_ids = friends.map(&:id)
      session[:friend_ids] ||= friend_ids
    end

    @friends = User.order_by_last_record.find_all_by_fb_id(session[:friend_ids])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @records }
      format.js
    end
  end

  # GET /records/1
  # GET /records/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/new
  # GET /records/new.xml
  def new
    @realtime = params[:type] != 'add'
    @record = Record.new(:time => Time.zone.now, :status => @realtime)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @record }
    end
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.xml
  def create
    @record = @me.records.new(params[:record])

    respond_to do |format|
      if @record.save
        wall_partial
        flash[:notice] = 'Record was successfully created.'
        format.html { redirect_to(@record) }
        format.js
      else
        flash[:notice] = 'Record was created fail.'
        format.html { render :action => "new" }
        format.js   { render :update do |page| 
          page.call(:alert, @record.errors.full_messages.join(','))
        end
        }
      end
    end
  end

  # PUT /records/1
  # PUT /records/1.xml
  def update

    respond_to do |format|
      if @record.update_attributes(params[:record])
        wall_partial
        flash[:notice] = 'Record was successfully updated.'
        format.html { redirect_to(@record) }
        format.js
      else
        format.html { render :action => "edit" }
        format.js   { render :update do |page| 
          page.call(:alert, @record.errors.full_messages.join(','))
        end
        }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.xml
  def destroy
    @record.destroy
    @me.status.cal_total_score(session[:friend_ids])

    respond_to do |format|
      format.html { redirect_to(records_url) }
      format.xml  { head :ok }
      format.js
    end
  end

  private
  def get_date_range
    @startDate = params[:startDate] ||= Time.zone.now.at_beginning_of_day.ago(7.days).to_s(:date)
    @endDate = params[:endDate] ||=Time.zone.now.at_beginning_of_day.to_s(:date)
  end

  def find_record
    @record = @me.records.find(params[:id])
  end

  def wall_partial
    status = @me.status
    status.cal_total_score(session[:friend_ids])

    @status_partial = "#{t('record.wake')}:#{@record.time.to_s(:hm)} 
    #{t('status.average')}:#{status.average.strftime("%H:%M")} 
    #{t('status.cont')}:#{status.continuous_num}"
    result = @record.success ? t('record.success') : t('record.fail')
    @result = "#{t('common.result')}: #{result}"
  end

end
