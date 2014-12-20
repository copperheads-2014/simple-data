Rails.application.routes.draw do

  # resources :services do
  #   resources :records, only: [:index, :show]
  # end

  get "/services/:service_name", to: "service#show"


end
