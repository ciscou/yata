class AddRepeatEveryToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :repeat_every, :string
  end
end
