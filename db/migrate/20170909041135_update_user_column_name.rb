class UpdateUserColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :entries, :stuff, :person
  end
end
