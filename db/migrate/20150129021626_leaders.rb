class Leaders < ActiveRecord::Migration
  def change
    create_table "leaders" do |t|
      t.string :leader_name
      t.string :leader_email
      t.string :password
      t.string :leader_stripe_key
      t.timestamps 
    end
  end
end
