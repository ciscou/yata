class Category < ActiveRecord::Base
  default_scope -> { order(:id) }

  belongs_to :user
  has_many :tasks, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
end
