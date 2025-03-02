class AppointmentsController < ApplicationController
  before_action :set_appointment, only: %i[ show update destroy ]

  def index
    @appointments = Appointment.all

    render json: @appointments
  end

  def detailed_index # possible params: doctor_name, patient_name, date_start, date_end
    # ex.: localhost:3000/appointments_detailed?patient_name=patient2&date_start=2024-11-01

    # Using Rails ORM (without including filter params):
    # @appointments = Appointment.includes(:doctor, :patient, :specialization)
    # appointments_details = @appointments.map do |appointment|
    #   {
    #     date: appointment.time,
    #     doctor: "#{appointment.doctor.firstname} #{appointment.doctor.surname}",
    #     patient: "#{appointment.patient.firstname} #{appointment.patient.surname}",
    #     specialization: appointment.specialization.name
    #   }
    # end

    sql = "SELECT d.firstname || ' ' || d.surname as doctor, a.time as date, s.name as specialization, p.firstname || ' ' || p.surname as patient
            FROM doctors d
            INNER JOIN appointments a
              ON d.id = a.doctor_id
            INNER JOIN patients p
              ON a.patient_id = p.id
            INNER JOIN specializations s
              ON a.specialization_id = s.id"
    filter_criteria = []
    values = []

    if params[:doctor_name].present?
      filter_criteria.push("d.firstname || ' ' || d.surname LIKE ?")
      values.push("%#{params[:doctor_name]}%")
    end
    if params[:patient_name].present?
      filter_criteria.push("p.firstname || ' ' || p.surname LIKE ?")
      values.push("%#{params[:patient_name]}%")
    end
    if params[:date_start].present? && params[:date_end].present?
      filter_criteria.push("a.time BETWEEN ? AND ?")
      values.push(params[:date_start], params[:date_end])
    end
    if params[:date_start].present? && !params[:date_end].present?
      filter_criteria.push("a.time > ?")
      values.push(params[:date_start])
    end

    if filter_criteria!= []
      sql = sql + " WHERE " + filter_criteria.join(" AND ")
    end
    sql = sql + " ORDER BY a.time"

    list = ActiveRecord::Base.connection.execute(ActiveRecord::Base.send(:sanitize_sql_array, [ sql, *values ]))

    render json: list
  end

  # GET /appointments/1
  def show
    render json: @appointment
  end

  # POST /appointments
  def create
    @appointment = Appointment.new(appointment_params)

    if @appointment.save
      render json: @appointment, status: :created, location: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if @appointment.update(appointment_params)
      render json: @appointment
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1
  def destroy
    @appointment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.expect(appointment: [ :time, :patient_id, :doctor_id, :specialization_id ])
    end
end
