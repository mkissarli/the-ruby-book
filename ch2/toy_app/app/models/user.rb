class User < ApplicationRecord
  has_many :microposts

  validates :name, presence: true
  validates :email, presence: true
  
  def has_micropost
    (self.microposts.length() >= 1)
  end
 
end
