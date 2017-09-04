class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.string :username
      t.string :password
      t.string :subdomain

      t.timestamps
    end
  end
end
