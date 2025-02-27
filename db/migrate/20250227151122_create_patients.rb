class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.string :firstname, limit: 50, null: false
      t.string :surname, limit: 50, null: false
      t.date :birthdate
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
