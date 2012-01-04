class AddAccountToUser < ActiveRecord::Migration
  def change
    add_column :user, :accountid, :string 
  end
end
