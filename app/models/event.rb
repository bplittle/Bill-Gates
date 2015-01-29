class Event < ActiveRecord::Base
  belongs_to :leader
  has_many :followers
  validates :event_name, :unit_price, presence: true
end