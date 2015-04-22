class User < ActiveRecord::Base
  has_many :ownerships, dependent: :destroy
  has_many :tasks, through: :ownerships
  has_many :categories, dependent: :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def clear_done_tasks
    tasks.done.each do |task|
      tasks.destroy task
    end
  end

  def category_names
    tasks
      .select('distinct(category_name)')
      .reorder(nil).where.not(category_name: [nil, ''])
      .pluck(:category_name)
  end
end
