class CreateDoctors < ActiveRecord::Migration[8.0]
  def change
    create_table :doctors do |t|
      t.string :firstname, limit: 50, null: false
      t.string :surname, limit: 50, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
