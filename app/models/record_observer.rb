class RecordObserver < ActiveRecord::Observer
  def after_save(record)
    if record.time_changed?
      @user = record.user
      update_user_status(record)
    end
  end

  def after_create(record)
    Status.increment_counter(:num, record.user.status.id)
  end

  def after_destroy(record)
    @user = record.user
    update_user_status(record)
    Status.decrement_counter(:num, record.user.status.id)
  end

  def update_user_status(record)
    @user.status.state = @user.records.cal_today_state
    @user.status.average = @user.records.cal_average
    @user.status.success_rate = @user.records.cal_success_rate
    @user.status.continuous_num = @user.records.cal_continuous_num
    @user.status.score = @user.records.cal_score if record.status  #即時才需要算分數
    @user.status.last_record_at = @user.records.order_by('time').first ? @user.records.order_by('time').first.time : nil
    @user.status.save!
  end
end
