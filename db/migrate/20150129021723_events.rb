class Events < ActiveRecord::Migration
  def change
     create_table "events" do |t|
      t.string :event_name
      t.string :date
      t.string :time
      t.string :leader_id
      t.string :location
      t.string :event_url
      t.integer :unit_price
      t.timestamps 
    end
  end
end
