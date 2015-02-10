class Ownership < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  after_destroy :destroy_task_if_orphan

  def destroy_task_if_orphan
    task.destroy if task.users.empty?
  end
end
