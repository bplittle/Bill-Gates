class Follower < ActiveRecord::Base
  belongs_to :event
  validates :follower_name, :follower_email, presence: true

end