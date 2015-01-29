class Follower < ActiveRecord::Base
  belongs_to :event
  validates :follower_email, presence: true

end