class AddErrorMessageToImportMember < ActiveRecord::Migration
  def change
    add_column :import_members, :error_message, :string
  end
end
