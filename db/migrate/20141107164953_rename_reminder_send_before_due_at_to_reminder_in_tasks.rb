class RenameReminderSendBeforeDueAtToReminderInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :reminder_send_before_due_at, :reminder
  end
end
