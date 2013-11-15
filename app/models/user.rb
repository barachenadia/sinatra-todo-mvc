class User < ActiveRecord::Base
  validates :username, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
