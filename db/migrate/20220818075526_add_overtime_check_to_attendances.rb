class AddOvertimeCheckToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_check, :boolean, default: false, null: false
  end
end
