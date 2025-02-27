class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :number, limit: 50
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
