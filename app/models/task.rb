class Task < ActiveRecord::Base
  SCOPES = %w[delayed today tomorrow todo done]

  default_scope order(:due_at)

  scope :todo, where(:done => false)
  scope :done, where(:done => true)

  scope :delayed , lambda { todo.where("due_at < ?", Time.current) }
  scope :today   , lambda { todo.where("due_at < ?", Time.current.end_of_day) }
  scope :tomorrow, lambda { todo.where("due_at between ? and ?", Time.current.tomorrow.beginning_of_day, Time.current.tomorrow.end_of_day) }

  scope :pending_to_send_reminder, lambda { todo.where(:reminder_sent => false).where("due_at < ?", Time.current + 1.hour) }

  belongs_to :user

  validates :name, :due_at, :presence => true
  validate  :chronic_parsed_humanized_due_at

  def self.send_reminders
    pending_to_send_reminder.includes(:user).find_each do |task|
      ReminderEmail.reminder_email(task).deliver
      task.update_attribute(:reminder_sent, true)
    end
  end

  def humanized_due_at
    @humanized_due_at ||= due_at.to_s
  end

  def humanized_due_at=(s)
    @humanized_due_at = s
    self.due_at = Chronic.parse(s)
  end

  private

  def chronic_parsed_humanized_due_at
    errors.add(:humanized_due_at, "is not a valid date") unless due_at
  end
end
