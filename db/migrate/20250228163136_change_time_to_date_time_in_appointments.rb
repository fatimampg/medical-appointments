class ChangeTimeToDateTimeInAppointments < ActiveRecord::Migration[8.0]
  def change
    change_column :appointments, :time, :datetime, null: false
  end
end
