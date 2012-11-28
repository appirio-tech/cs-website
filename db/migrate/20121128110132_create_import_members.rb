class CreateImportMembers < ActiveRecord::Migration
  def change
    create_table :import_members do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :school
      t.string :membername
      t.string :sfdc_username
      t.string :temp_password
      t.string :campaign_medium
      t.string :campaign_source
      t.string :campaign_name

      t.timestamps
    end
  end
end
