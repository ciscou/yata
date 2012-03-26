class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.datetime :due_at
      t.boolean :done, :default => false

      t.timestamps
    end
  end
end
