class TaskMailer < ActionMailer::Base
  helper :tasks, :markdown

  def reminder(task, email)
    @task = task
    mail(from: "reminders@y-a-t-a.herokuapp.com", to: email, subject: "[Yata] #{task.name}")
  end

  def share(task, from, to)
    @task = task
    mail(from: from, to: to, subject: "[Yata] #{task.name}")
  end
end
