class CreateOvertimes < ActiveRecord::Migration[5.1]
  def change
    create_table :overtimes do |t|
      t.datetime :schedule
      t.boolean :next_day
      t.string :biz_memo
      t.string :confirmation

      t.timestamps
    end
  end
end
