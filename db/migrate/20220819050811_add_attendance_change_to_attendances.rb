class AddAttendanceChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :attendance_change_check, :boolean
    add_column :attendances, :attendance_chage_flag, :boolean
  end
end
