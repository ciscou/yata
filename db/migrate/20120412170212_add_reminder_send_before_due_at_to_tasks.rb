class AddReminderSendBeforeDueAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :reminder_send_before_due_at, :integer

  end
end
