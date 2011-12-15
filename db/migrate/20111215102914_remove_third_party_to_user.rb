class RemoveThirdPartyToUser < ActiveRecord::Migration
  def up
    remove_column :Users, :third_party_service
    remove_column :Users, :third_party_service
  end

  def down
    add_column :Users, :third_party_service, :string
    add_column :Users, :third_party_service, :string
  end
end
