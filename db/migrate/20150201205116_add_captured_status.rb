class AddCapturedStatus < ActiveRecord::Migration
  def change
    add_column :events, :captured_status, :boolean, default: false
  end
end
