class DropUsersTable < ActiveRecord::Migration[5.1]
  def change
    remove_index(:users, :name => 'index_users_on_email')
    drop_table :users
    
  end
end
