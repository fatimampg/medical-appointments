class RemoveDateFromAppointments < ActiveRecord::Migration[8.0]
  def change
    remove_column :appointments, :date, :date
  end
end
