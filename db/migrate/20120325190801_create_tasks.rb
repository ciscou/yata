class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :frequency
      t.datetime :due_at
      t.datetime :reminder_at
      t.boolean :reminder_sent

      t.timestamps
    end
  end
end
