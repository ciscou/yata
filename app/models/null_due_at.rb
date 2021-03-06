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

  def year
    -1
  end

  def month
    -1
  end

  def day
    -1
  end

  def wday
    999
  end

  def as_json
    nil
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
