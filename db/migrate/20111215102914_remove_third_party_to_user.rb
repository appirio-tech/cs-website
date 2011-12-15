class RemoveThirdPartyToUser < ActiveRecord::Migration
  def up
    remove_column :users, :third_party_service
    remove_column :users, :third_party_username
  end

  def down
    add_column :users, :third_party_service, :string
    add_column :users, :third_party_username, :string
  end
end
