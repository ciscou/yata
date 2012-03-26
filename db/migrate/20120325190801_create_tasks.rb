class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :frequency
      t.datetime :due_at
      t.datetime :reminder_at
      t.boolean :reminder_sent, :default => false
      t.boolean :done, :default => false

      t.timestamps
    end
  end
end
