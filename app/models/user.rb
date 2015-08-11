class User < ActiveRecord::Base
  has_many :ownerships, dependent: :destroy
  has_many :tasks, through: :ownerships

  # Shamelessly stolen from https://gist.github.com/josevalim/fb706b1e933ef01e4fb6
  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

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

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
