class RemoveThirdPartyUsernameFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :third_party_username
  end

  def down
    add_column :users, :third_party_username, :string
  end
end
