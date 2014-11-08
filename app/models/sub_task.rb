class SubTask < ActiveRecord::Base
  default_scope -> { order(:id) }

  belongs_to :task

  validates :name, presence: true
end
