class Leader < ActiveRecord::Base
  has_many :events
  validates :leader_name, :leader_email, :password, 
  :leader_stripe_key, presence: true 
  validates :leader_email, uniqueness: true
end