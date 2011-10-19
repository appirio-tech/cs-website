class AddSfdcUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sfdc_username, :string
  end
end
