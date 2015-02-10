class User < ActiveRecord::Base
  has_many :ownerships, dependent: :destroy
  has_many :tasks, through: :ownerships
  has_many :categories, dependent: :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
