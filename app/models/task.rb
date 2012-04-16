class Task < ActiveRecord::Base
  SCOPES = {
    :delayed  => "Delayed",
    :today    => "Today",
    :tomorrow => "Tomorrow",
    :later    => "Later",
    :todo     => "See all",
    :done     => "Done"
  }.with_indifferent_access

  default_scope order(:due_at)

  scope :todo, where(:done => false)
  scope :done, where(:done => true)

  scope :delayed , lambda { todo.where("due_at < ?", Time.current) }
  scope :today   , lambda { todo.where("due_at > ? and due_at < ?", Time.current, Time.current.end_of_day) }
  scope :tomorrow, lambda { todo.where("due_at between ? and ?", Time.current.tomorrow.beginning_of_day, Time.current.tomorrow.end_of_day) }
  scope :later   , lambda { todo.where("due_at > ?", Time.current.tomorrow.end_of_day) }

  scope :pending_to_send_reminder, lambda {
    todo.where(:reminder_sent => false).
    where("reminder_send_before_due_at is not null").
    where("due_at - reminder_send_before_due_at * interval '1 minute' < ?", Time.current)
  }

  before_save :reset_reminder_sent, :if => :due_at_or_reminder_send_before_due_at_changed?

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
    @humanized_due_at ||= begin
                            if due_at
                              due_at.to_s(:short)
                            else
                              ""
                            end
                          end
  end

  def humanized_due_at=(s)
    @humanized_due_at = s
    self.due_at = Chronic.parse(s)
  end

  def todo?
    not done?
  end

  def delayed?
    todo? and due_at.past?
  end

  private

  def chronic_parsed_humanized_due_at
    errors.add(:humanized_due_at, "is not a valid date") unless due_at
  end

  def reset_reminder_sent
    self.reminder_sent = false
    true
  end

  def due_at_or_reminder_send_before_due_at_changed?
    due_at_changed? or reminder_send_before_due_at_changed?
  end
end
