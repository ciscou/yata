class ReminderEmail < ActionMailer::Base
  default from: "reminders@yata.com"

  def reminder_email(task)
    @task = task
    mail(:to => task.user.email, :subject => "Reminder for task #{task.name.inspect}")
  end
end
