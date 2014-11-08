class Category < ActiveRecord::Base
  default_scope -> { order(:name) }

  belongs_to :user
  has_many :tasks, dependent: :nullify

  validates :name, presence: true
end
