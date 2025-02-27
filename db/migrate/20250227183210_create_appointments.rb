class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.date :date, null: false
      t.time :time, null: false
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
