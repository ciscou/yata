class User < ActiveRecord::Base
  has_many :ownerships, dependent: :destroy
  has_many :tasks, through: :ownerships

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def clear_done_tasks
    tasks.done.each do |task|
      tasks.destroy task
    end
  end

  def categories
    tasks
      .select('distinct(category)').reorder(nil)
      .map(&:category).select(&:present?)
  end
end
