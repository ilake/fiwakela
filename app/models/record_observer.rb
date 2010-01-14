class RecordObserver < ActiveRecord::Observer
  def after_save(record)
    if record.time_changed?
      init_data(record)
      update_user_status
    end
  end

  def after_create(record)
    init_data(record)
    @status.num += 1
  end

  def after_destroy(record)
    init_data(record)

    @status.num -= 1
    update_user_status
  end

  def update_user_status
    @status.state          = @records.cal_today_state
    @status.average        = @records.cal_average
    @status.success_rate   = @records.cal_success_rate
    @status.continuous_num = @records.cal_continuous_num
    @status.score          = @records.cal_score if @record.status  #即時才需要算分數
    @status.last_record_at = @records.order_by('time').first ? @records.order_by('time').first.time : nil

    @status.update_badges(@status.num, @status.continuous_num)
    @status.save!
  end

  def init_data(record)
    @record ||= record
    @user ||= record.user
    @status ||= @user.status
    @records ||= @user.records
  end
end
