Rails.application.routes.draw do


  resources :users, except: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :organizations, only: [:new, :create]

  # resources :services do
  #   resources :records, only: [:index, :show]
  # end
root 'application#index'
  get "/services/:service_slug", to: "services#show"
  get "/services", to: "services#index"
  get "/services/new", to: "services#new"
  post "/services", to: "services#create"
  get "/services/:service_slug/edit", to: "services#edit"
  put "/services/:service_slug", to: "services#update"
  delete "/services/:service_slug", to: "services#destroy"

  get "/services/:service_slug/records", to: "records#index"


end
