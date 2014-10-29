class TaskMailer < ActionMailer::Base
  helper :tasks

  def reminder(task)
    @task = task
    mail(from: "reminders@yata.com", to: task.user.email, subject: "Reminder for task #{task.name.inspect}")
  end

  def share(task)
    @task = task
    mail(from: task.user.email, to: email, subject: "I want to share a task with you!")
  end
end
