class Task < ActiveRecord::Base
  SCOPES = %w[delayed today tomorrow todo done]

  default_scope order(:due_at)

  scope :todo, where(:done => false)
  scope :done, where(:done => true)

  scope :delayed , lambda { todo.where("due_at < ?", Time.current) }
  scope :today   , lambda { todo.where("due_at < ?", Time.current.end_of_day) }
  scope :tomorrow, lambda { todo.where("due_at between ? and ?", Time.current.tomorrow.beginning_of_day, Time.current.tomorrow.end_of_day) }

  validates :name, :due_at, :presence => true

  def humanized_due_at
    @humanized_due_at ||= due_at.to_s
  end

  def humanized_due_at=(s)
    @humanized_due_at = s
    self.due_at = Chronic.parse(s)
  end
end
