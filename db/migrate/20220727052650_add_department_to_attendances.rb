class AddDepartmentToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime, :datetime
  end
end
