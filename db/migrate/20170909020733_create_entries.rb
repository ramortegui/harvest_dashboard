class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.bigint :entry_id
      t.date :date
      t.string :organization
      t.string :client
      t.string :project
      t.boolean :active
      t.string :task
      t.string :stuff
      t.float :hours

      t.timestamps
    end
  end
end
