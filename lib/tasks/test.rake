namespace :test_db do
  desc "config test database"
  task setup: :environment do
    puts "Reseting test database"

    system("rails db:drop")
    system("rails db:create")
    system("rails db:migrate")
    # system("RAILS_ENV=test rails db:drop")
    # system("RAILS_ENV=test rails db:create")
    # system("RAILS_ENV=test rails db:migrate")

    puts "Creating users"

    email = [ "admin@test.com", "doctor1@test.com", "doctor2@test.com", "patient1@test.com", "patient2@test.com" ]
    role = [ "admin", "doctor", "doctor", "patient", "patient" ]
    password = [ "01230123" ]
    i=0
    for i in 0...email.length do
      User.create!(
        email: email[i],
        password: password[0],
        role: role[i]
      )
    end

    user_with_role_doctor = User.where(role: "doctor")
    user_with_role_patient = User.where(role: "patient")

    puts "Creating doctors"
    doctor1 = Doctor.create!(
      user_id: user_with_role_doctor[0].id,
      firstname: "doctor1firstname",
      surname: "doctor1surname"
    )
    doctor2 = Doctor.create!(
      user_id: user_with_role_doctor[1].id,
      firstname: "doctor2firstname",
      surname: "doctor2surname"
    )

    puts "Creating specializations"
    specializations = [ "allergy and immunology", "dermatology", "family medicine", "internal medicine", "neurology", "obstetrics and gynecology", "pediatrics" ]
    specializations.each do |specialization|
      Specialization.create!(
        name: specialization
      )
    end

    puts "Associating specializations to doctors"
    special1 = Specialization.find_by(name: "family medicine")
    special2 = Specialization.find_by(name: "internal medicine")
    special3 = Specialization.find_by(name: "dermatology")
    DoctorsSpecialization.create!(doctor_id: doctor1.id, specialization_id: special1.id)
    DoctorsSpecialization.create!(doctor_id: doctor1.id, specialization_id: special2.id)
    DoctorsSpecialization.create!(doctor_id: doctor2.id, specialization_id: special3.id)

    puts "Creating patients"
    patient1 = Patient.create!(
      user_id: user_with_role_patient[0].id,
      firstname: "patient1firstname",
      surname: "patient1surname",
      birthdate: Date.new(1990, 1, 1)
    )
    patient2 = Patient.create!(
      user_id: user_with_role_patient[1].id,
      firstname: "patient2firstname",
      surname: "patient2surname",
      birthdate: Date.new(1980, 1, 1)
    )

    puts "Creating contacts and address"
    contacts = (0..4).map { |n| n.to_s * 9 }
    street = (1..4).map { |n| "street#{n}" }
    city = (1..4).map { |n| "city#{n}" }
    country = "Portugal"

    users = [ doctor1, doctor2, patient1, patient2 ]
    users.each_with_index do |user, index|
      Contact.create!(
        user_id: user.id,
        number: contacts[index],
      )
    end
    Contact.create!(user_id: users[0].id, number: contacts[4])

    users.each_with_index do |user, index|
      Address.create!(
        user_id: user.id,
        street: street[index],
        city: city[index],
        country: country,
      )
    end

    puts "Creating appointments"
    appointment1 = Appointment.create!(time: DateTime.new(2024, 2, 1, 10, 00, 00), patient_id: patient1.id, doctor_id: doctor1.id, specialization_id: special1.id)
    appointment2 = Appointment.create!(time: DateTime.new(2025, 2, 1, 10, 00, 00), patient_id: patient1.id, doctor_id: doctor1.id, specialization_id: special1.id)
    appointment3 = Appointment.create!(time: DateTime.new(2024, 9, 1, 10, 00, 00), patient_id: patient2.id, doctor_id: doctor1.id, specialization_id: special2.id)
    appointment4 = Appointment.create!(time: DateTime.new(2025, 1, 1, 10, 00, 00), patient_id: patient2.id, doctor_id: doctor2.id, specialization_id: special3.id)
  end
end
