class Task < ActiveRecord::Base
  default_scope order(:due_at)
end
