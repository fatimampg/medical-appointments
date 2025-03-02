Rails.application.routes.draw do
  resources :appointments, only: [ :index, :show, :create, :update, :destroy ]
  resources :doctors
  resources :patients
  resources :specializations
  # resources :doctors_specializations

  # get list of appointments, showing doctor's full name, patient's full name, date and specialization - filter by patient full name, doctor full name and/or dates (query params)
  get "appointments_detailed", to: "appointments#detailed_index"

  # get list of doctors with specialization(s) - filter by doctor's firstname, surname and/or specialization (query params)
  get "doctors_detailed", to: "doctors#index_with_specialization"

  mount_devise_token_auth_for "User", at: "auth"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
