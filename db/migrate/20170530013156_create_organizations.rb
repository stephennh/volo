class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :location
      t.string :email
      t.integer :phone_number
      t.timestamps
    end
  end
end
