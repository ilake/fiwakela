module Common
  def self.cal_days_interval(time1, time2)
    interval_days = ((time2 - time1)/86400).ceil
    interval_days = 1 if interval_days.zero?
    interval_days
  end

  #[[2008, 11, 5, 30.0], [2008, 11, 6, 2.0] => "[[2008, 11, 5, 30.0], [2008, 11, 6, 2.0]]"
  def self.time_to_string(records, time_type)
    time = ""

    if time_type == "time"
      records.each do |record|
        todo_time = record.time
        #time << "['#{todo_time.to_s(:fulltime)}', #{todo_time.hour + todo_time.min/60.0}],"
        time << "[#{todo_time.to_i*1000}, #{todo_time.hour + todo_time.min/60.0}],"
      end
    else
      records.each do |record|
        target_time = record.target_time
        if target_time
          time << "[#{target_time.to_i*1000}, #{target_time.hour + target_time.min/60.0}],"
        end
      end
    end
    time.chop!
    "[#{time}]"
  end 

end
