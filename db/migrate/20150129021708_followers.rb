class Followers < ActiveRecord::Migration
  def change
     create_table "followers" do |t|
      t.string :follower_name
      t.string :follower_email
      t.integer :event_id
      t.integer :unit_quantity
      t.integer :unit_total_price
      t.string :stripe_token
      t.string :status
      t.timestamps 
    end
  end

end
