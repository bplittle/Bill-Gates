class AddIndex < ActiveRecord::Migration
  
  add_index :followers, :event_id
  add_index :events, :leader_id
end
