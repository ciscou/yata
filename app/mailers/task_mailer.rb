class TaskMailer < ActionMailer::Base
  helper :tasks, :markdown

  def reminder(task, email)
    @task = task
    mail(from: "reminders@y-a-t-a.herokuapp.com", to: email, subject: "Reminder for task #{task.name.inspect}")
  end

  def share(task, from, to)
    @task = task
    mail(from: from, to: to, subject: "I want to share a task with you!")
  end
end
