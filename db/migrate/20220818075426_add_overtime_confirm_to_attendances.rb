class AddOvertimeConfirmToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_confirm, :integer
  end
end
