class Task < ActiveRecord::Base
  default_scope order(:due_at)

  scope :todo, where(:done => false)
  scope :done, where(:done => true)

  scope :today   , lambda { todo.where("due_at <= ?", Time.current.end_of_day) }
  scope :tomorrow, lambda { todo.where("due_at between ? and ?", Time.current.tomorrow.beginning_of_day, Time.current.tomorrow.end_of_day) }
end
