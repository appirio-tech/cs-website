class RemoveThirdPartyUsernameFromUser < ActiveRecord::Migration
  def up
    remove_column :user, :third_party_username
  end

  def down
    add_column :user, :third_party_username, :string 
  end
end
