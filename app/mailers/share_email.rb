class ShareEmail < ActionMailer::Base
  helper :tasks

  default subject: "I want to share a task with you!"

  def share_email(task, email)
    @task = task
    mail(from: task.user.email, to: email)
  end
end
