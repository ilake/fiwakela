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
    status = @user.status
    records = @user.records
    status.state          = records.cal_today_state
    status.average        = records.cal_average
    status.success_rate   = records.cal_success_rate
    status.continuous_num = records.cal_continuous_num
    status.score          = records.cal_score if record.status  #即時才需要算分數
    status.last_record_at = records.order_by('time').first ? records.order_by('time').first.time : nil

    status.update_badges(status.num, status.continuous_num)
    status.save!
  end
end
