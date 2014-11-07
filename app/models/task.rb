class Task < ActiveRecord::Base
  SCOPES = {
    delayed:  "Delayed",
    today:    "Today",
    tomorrow: "Tomorrow",
    later:    "Later",
    todo:     "See all",
    done:     "Done"
  }.with_indifferent_access

  default_scope -> { order(:due_at) }

  scope :todo, -> { where(done: false) }
  scope :done, -> { where(done: true) }

  scope :delayed , -> { todo.where("due_at < ?", Time.current) }
  scope :today   , -> { todo.where("due_at > ? and due_at < ?", Time.current, Time.current.end_of_day) }
  scope :tomorrow, -> { todo.where("due_at between ? and ?", Time.current.tomorrow.beginning_of_day, Time.current.tomorrow.end_of_day) }
  scope :later   , -> { todo.where("due_at > ?", Time.current.tomorrow.end_of_day) }

  scope :pending_to_send_reminder, -> {
    todo.where(:reminder_sent => false).
    where("reminder_send_before_due_at is not null").
    where("due_at - reminder_send_before_due_at * interval '1 minute' < ?", Time.current)
  }

  before_save :reset_reminder_sent, :if => :due_at_or_reminder_send_before_due_at_changed?
  before_save :ensure_url_has_http_protocol, :if => :url?

  belongs_to :user

  validates :name, :due_at, :presence => true
  validate  :chronic_parsed_humanized_due_at

  def self.send_reminders
    pending_to_send_reminder.includes(:user).find_each(&:send_reminder)
  end

  def send_reminder
    TaskMailer.reminder(self).deliver
    update_attribute(:reminder_sent, true)
  end

  def toggle_done!
    toggle!(:done)
  end

  def humanized_due_at_before_type_cast
    @humanized_due_at_before_type_cast || humanized_due_at
  end

  def humanized_due_at
    due_at.to_s(:short) if due_at?
  end

  def humanized_due_at=(s)
    @humanized_due_at_before_type_cast = s
    self.due_at = Chronic.parse(s)
  end

  def todo?
    !done?
  end

  def delayed?
    todo? && due_at.past?
  end

  def ensure_token!
    update_attributes!(token: SecureRandom.hex) unless token?
  end

  def build_accept_for(user)
    user.tasks.new attributes.slice("name", "due_at", "reminder_send_before_due_at", "url", "location", "description")
  end

  private

  def chronic_parsed_humanized_due_at
    errors.add(:humanized_due_at, "is not a valid date") unless due_at
  end

  def reset_reminder_sent
    self.reminder_sent = false
    true
  end

  def ensure_url_has_http_protocol
    self.url = "http://#{url}" unless url =~ %r{\Ahttps?://}
    true
  end

  def due_at_or_reminder_send_before_due_at_changed?
    due_at_changed? || reminder_send_before_due_at_changed?
  end
end
