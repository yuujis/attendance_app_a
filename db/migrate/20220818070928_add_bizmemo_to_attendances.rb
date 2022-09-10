class AddBizmemoToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :bizmemo, :string
  end
end
