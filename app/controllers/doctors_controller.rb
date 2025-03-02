class DoctorsController < ApplicationController
  before_action :set_doctor, only: %i[ show update destroy ]

  # GET /doctors
  def index
    @doctors = Doctor.all

    render json: @doctors
  end

  def index_with_specialization # possible params: doctor_firstname, doctor_surname, specialization_name
    # localhost:3000/doctors_detailed - same as index, but includes column with specialization name (many to many relationship)
    # ex.: localhost:3000/doctors_detailed?doctor_firstname=doctor1firstname&doctor_surname=doctor1surname&specialization_name=family%20medicine

    # if params[:specialization_name]
    #   @doctors = Doctor.includes(:specializations).joins(:specializations).where(specializations: { name: params[:specialization_name] })
    # end
    # if params[:doctor_firstname].present? && params[:doctor_lastname] && params[:specialization_name]
    #   @doctors = Doctor.includes(:specialization).where("LOWER(firstname) LIKE ? AND LOWER(surname) LIKE ?", params[:doctor_firstname], params[:doctor_surname]).where(specializations: { name: params[:specialization_name] })
    # end
    # doctor_detailed_list = @doctors.map do |doctor|
    #   {
    #     doctor: "#{doctor.firstname} #{doctor.surname}",
    #     specialization:
    #   }
    # end

    sql = "SELECT d.firstname || ' ' || d.surname as doctor,
      s.name as specialization
      FROM doctors d
      INNER JOIN doctors_specializations ds
        ON d.id = ds.doctor_id
      INNER JOIN specializations s
        ON ds.specialization_id=s.id"
    filter_criteria = []
    values = []

    if params[:specialization_name].present?
      filter_criteria.push("LOWER(s.name) LIKE ?")
      values.push("%#{params[:specialization_name]}%")
    end
    if params[:doctor_firstname].present?
      filter_criteria.push("LOWER(d.firstname) LIKE ?")
      values.push("%#{params[:doctor_firstname]}%")
    end
    if params[:doctor_surname].present?
      filter_criteria.push("LOWER(d.surname) LIKE ?")
      values.push("%#{params[:doctor_surname]}%")
    end

    if filter_criteria!= []
      sql = sql + " WHERE " + filter_criteria.join(" AND ")
    end
    sql = sql + " ORDER BY d.firstname"

    list = ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, [ sql, *values ]))

    render json: list
  end

  # GET /doctors/1
  def show
    render json: @doctor
  end

  # POST /doctors
  def create
    @doctor = Doctor.new(doctor_params)

    if @doctor.save
      render json: @doctor, status: :created, location: @doctor
    else
      render json: @doctor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doctors/1
  def update
    if @doctor.update(doctor_params)
      render json: @doctor
    else
      render json: @doctor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /doctors/1
  def destroy
    @doctor.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @doctor = Doctor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def doctor_params
      params.expect(doctor: [ :firstname, :surname, :user_id ])
    end
end
