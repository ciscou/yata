class Task < ActiveRecord::Base
  SCOPES = {
    delayed:     "Delayed",
    today:       "Today",
    tomorrow:    "Tomorrow",
    later:       "Later",
    unscheduled: "Unscheduled",
    todo:        "See all",
    done:        "Done"
  }.with_indifferent_access.freeze

  default_scope -> { order(:due_at) }

  scope :todo, -> { where(done: false) }
  scope :done, -> { reorder(due_at: :desc).where(done: true) }

  scope :scheduled,   -> { todo.where.not(due_at: nil) }
  scope :unscheduled, -> { todo.where(due_at: nil) }

  scope :delayed,  -> { scheduled.where("due_at < ?", Time.current) }
  scope :today,    -> { scheduled.where("due_at > ? and due_at < ?", Time.current, Time.current.end_of_day) }
  scope :tomorrow, -> { scheduled.where("due_at between ? and ?", Time.current.tomorrow.beginning_of_day, Time.current.tomorrow.end_of_day) }
  scope :later,    -> { scheduled.where("due_at > ?", Time.current.tomorrow.end_of_day) }

  scope :pending_to_send_reminder, -> {
    scheduled.where(reminder_sent: false).
    where("reminder is not null").
    where("due_at - reminder * interval '1 minute' < ?", Time.current)
  }

  has_many :sub_tasks, dependent: :destroy

  accepts_nested_attributes_for :sub_tasks, allow_destroy: true, reject_if: :all_blank

  before_save :reset_reminder_sent, if: :reminder_params_changed?
  before_save :ensure_url_has_http_protocol, if: :url?

  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validate  :chronic_parsed_humanized_due_at

  def self.send_reminders
    pending_to_send_reminder.includes(:user).find_each(&:send_reminder)
  end

  def send_reminder
    TaskMailer.reminder(self).deliver
    update_attribute(:reminder_sent, true)
  end

  def due_at
    read_attribute(:due_at) || NullDueAt.new
  end

  def mark_as_done!
    if repeat_every?
      self.due_at += periodicity
      save!
      self.done = true # after saving on purpose
    else
      self.done = true
      save!
    end
  end

  def unmark_as_done!
    if repeat_every?
      self.due_at -= periodicity
      save!
      self.done = false # after saving on purpose
    else
      self.done = false
      save!
    end
  end

  def humanized_due_at_before_type_cast
    @humanized_due_at_before_type_cast || humanized_due_at
  end

  def humanized_due_at
    due_at.to_s(:short) if due_at?
  end

  def humanized_due_at=(s)
    @humanized_due_at_before_type_cast = s

    if s.present?
      self.due_at = Chronic.parse(s)
      @humanized_due_at_error = due_at.nil?
    else
      self.due_at = nil
      @humanized_due_at_error = false
    end
  end

  def scheduled?
    !!due_at?
  end

  def unscheduled?
    !scheduled?
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
    user.tasks.new do |task|
      task.attributes = attributes.slice("name", "due_at", "repeat_every", "reminder", "url", "location", "description")
      task.sub_tasks_attributes = sub_tasks.map { |st| st.attributes.slice("name") }
    end
  end

  private

  def periodicity
    n, s = repeat_every.split
    n.to_i.send(s)
  end

  def chronic_parsed_humanized_due_at
    errors.add(:humanized_due_at, "is not a valid date") if @humanized_due_at_error
  end

  def reset_reminder_sent
    self.reminder_sent = false
    true
  end

  def ensure_url_has_http_protocol
    self.url = "http://#{url}" unless url =~ %r{\Ahttps?://}
    true
  end

  def reminder_params_changed?
    due_at_changed? || repeat_every_changed? || reminder_changed?
  end
end
