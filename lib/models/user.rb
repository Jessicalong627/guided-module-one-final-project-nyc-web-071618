class User < ActiveRecord::Base
  has_many :orders
  has_many :events, through: :orders

end
