class RemoveTokenAuthenticatableFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :authentication_token
  end

  def down
    add_column :users, :authentication_token, :string
    add_index  :users, :authentication_token, :unique => true
  end
end
