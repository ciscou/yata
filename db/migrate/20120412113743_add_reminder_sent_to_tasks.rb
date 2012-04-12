class AddReminderSentToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :reminder_sent, :boolean, :default => false
  end
end
