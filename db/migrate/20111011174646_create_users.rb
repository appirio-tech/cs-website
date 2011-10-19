class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :third_party_service
      t.string :third_party_username

      t.timestamps
    end
  end
end
