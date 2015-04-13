class NullDueAt
  def nil?
    true
  end

  def past?
    false
  end

  def to_date
    self
  end

  def strftime(format)
    "Unscheduled"
  end

  def +(duration)
    self
  end

  def -(duration)
    self
  end

  def wday
    999
  end

  def hash
    [self.class.name, wday].hash
  end

  def eql?(other)
    wday.eql? other.wday
  end

  def to_s(format = nil)
    case format
    when :time
      "--:--"
    else
      nil
    end
  end
end
