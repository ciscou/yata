class SubTask < ActiveRecord::Base
  belongs_to :task

  validates :name, presence: true
end
