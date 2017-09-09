class UpdateEntryColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :entries, :active, :project_active
  end
end
