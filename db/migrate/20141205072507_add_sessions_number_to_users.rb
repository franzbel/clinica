class AddSessionsNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sessions_number, :integer
  end
end
