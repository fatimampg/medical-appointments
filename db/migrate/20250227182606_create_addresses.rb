class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city, limit: 100
      t.string :country, limit: 100
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
