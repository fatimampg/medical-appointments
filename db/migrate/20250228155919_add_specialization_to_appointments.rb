class AddSpecializationToAppointments < ActiveRecord::Migration[8.0]
  def change
    add_reference :appointments, :specialization, foreign_key: true
  end
end
