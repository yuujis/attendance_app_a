module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end
  
  def over_time(endtime, designated_work_end_time, day)
    if day.next_day == true
      format("%.2f", (((Time.parse(endtime) - Time.parse(designated_work_end_time)) / 60) / 60.0) + 24)
    else
      format("%.2f", (((Time.parse(endtime) - Time.parse(designated_work_end_time)) / 60) / 60.0))
    end
  end

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def format_min(time)
    format("%.2d",((time.strftime('%M').to_i / 15).round)* 15)
  end
  
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end


  def working_overtimes(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0)-(60.0*8))
      
  end

end