class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :affiliation
      t.integer :employee_number
      t.string :uid
      t.time :basic_work_time, default: "08:00:00"
      t.time :designated_work_start_time, default: "09:00:00"
      t.time :designated_work_end_time, default: "18:00:00"
     

      t.timestamps
    end
  end
end
