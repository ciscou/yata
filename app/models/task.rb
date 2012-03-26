class Task < ActiveRecord::Base
  default_scope order(:due_at)

  scope :todo, where(:done => false)
  scope :done, where(:done => true)
end
