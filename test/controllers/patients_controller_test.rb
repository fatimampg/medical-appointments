require "test_helper"

class PatientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @patient = Patient.first

    # @patient = Patient.first || Patient.create!(firstname: "John", surname: "Doe", birthdate: "1990-01-01", user_id: 4)

    puts "setting patient"
    puts @patient.inspect
  end

  test "should get index" do
    get patients_url, as: :json
    assert_response :success
  end

  test "should create patient" do
    assert_difference("Patient.count") do
      post patients_url, params: { patient: { birthdate: @patient.birthdate, firstname: @patient.firstname, surname: @patient.surname, user_id: @patient.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show patient" do
    get patient_url(@patient), as: :json
    assert_response :success
  end

  test "should update patient" do
    patch patient_url(@patient), params: { patient: { birthdate: @patient.birthdate, firstname: @patient.firstname, surname: @patient.surname, user_id: @patient.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy patient if no appointments are assigned" do
    user = User.create(email: "newuser@test.com", password: "12345678", role: "patient")
    patient = Patient.create!(firstname: "ptname", surname: "ptsurname", user_id: user.id)
    assert_difference("Patient.count", -1) do
      delete patient_url(patient), as: :json
    end
  end


  test "should raise an ActiveRecord::DeleteRestrictionError when trying to destroy patient that has appointments" do
    puts @patient.inspect
    assert_raises(ActiveRecord::DeleteRestrictionError) do
      delete patient_url(@patient), as: :json
    end
  end
end
