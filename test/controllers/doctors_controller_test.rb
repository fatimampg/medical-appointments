require "test_helper"

class DoctorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # @doctor = doctors(:one)
    @doctor = Doctor.first
  end

  test "should get index" do
    get doctors_url, as: :json
    assert_response :success
  end

  test "should create doctor" do
    assert_difference("Doctor.count") do
      post doctors_url, params: { doctor: { firstname: @doctor.firstname, surname: @doctor.surname, user_id: @doctor.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show doctor" do
    get doctor_url(@doctor), as: :json
    assert_response :success
  end

  test "should update doctor" do
    patch doctor_url(@doctor), params: { doctor: { firstname: @doctor.firstname, surname: @doctor.surname, user_id: @doctor.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy doctor if no appointments are assigned" do
    puts @doctor.inspect
    user = User.create(email: "newuser@test.com", password: "12345678", role: "doctor")
    doctor = Doctor.create!(firstname: "drname", surname: "drsurname", user_id: user.id)
    assert_difference("Doctor.count", -1) do
      delete doctor_url(doctor), as: :json
    end

    assert_response :no_content
  end

  test "should raise an ActiveRecord::DeleteRestrictionError when trying to destroy doctor that has appointments" do
    puts @doctor.inspect
    assert_raises(ActiveRecord::DeleteRestrictionError) do
      delete doctor_url(@doctor), as: :json
    end
  end
end
